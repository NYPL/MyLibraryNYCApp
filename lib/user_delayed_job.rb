class UserDelayedJob < Struct.new(:user_id, :pin)

  def perform
    user = User.find(user_id)
    
    if user.blank?
      defensive_log("UserBarcodeJob called with nil user or pin.")
      raise Exceptions::ArgumentError, "UserBarcodeJob called with nil user or pin."
    end

    is_barcode_available = false
    
    number_tries = 0;
    while is_barcode_available == false && number_tries < 7
      begin
        number_tries += 1
        is_barcode_available = user.is_barcode_available_in_sierra
      rescue Exceptions::InvalidResponse => exception
        defensive_log("#{self.class.name}: user.check_barcode_uniqueness_with_sierra threw an error: #{exception.message || 'nil'}")
        raise exception
      end

      # barcode found to already be in Sierra for another user?
      # well, we can't be saving this user with a duplicate barcode.
      # ask the user to increment its barcode, and try again.
      unless is_barcode_available
        defensive_log("#{self.class.name}: barcode [#{user.barcode}] was already in Sierra, calling user.assign_barcode again")
        user.assign_barcode
        # wait a bit before hitting Sierra up again
        sleep(60)
      end

    end

    if is_barcode_available == true
      begin
        defensive_log("#{self.class.name}: barcode [#{user.barcode}] is available in Sierra, calling patron creator service.")
        response = user.send_request_to_patron_creator_service(pin)

        if response.code == 201
          defensive_log("Patron created successfully")
          # Send user account confirmation email
          user.account_confirmed_email_to_user
          defensive_log("#{self.class.name}: Patron creator service ran. Saving user in MLN db.")
          user.save_as_complete!
        end
        
      rescue Exceptions::InvalidResponse => exception
        defensive_log("#{self.class.name}: \
          send_request_to_patron_creator_service or user.save_as_complete threw: #{exception.message || 'nil'}")
        raise exception
      end
    else
      defensive_log("#{self.class.name}: UserBarcodeJob.perform: barcode_already_in_sierra still true")
    end
  end

  private

  def defensive_log(msg)
    unless Delayed::Worker.logger.blank?
      Delayed::Worker.logger.add(Logger::INFO, msg)
    end
  end
end
