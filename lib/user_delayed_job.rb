# frozen_string_literal: true

class UserDelayedJob < Struct.new(:user_id, :pin)

  def perform
    user = User.find(user_id)
    
    if user.blank?
      defensive_log("UserBarcodeJob called with nil user or pin.")
      raise Exceptions::ArgumentError, "UserBarcodeJob called with nil user or pin."
    end
    
    is_barcode_available = false
    number_tries = 0
    # barcode already found in Sierra for another user?
    # well, we can't be saving this user with a duplicate barcode.
    # ask the user to increment the barcode, and try again.
    while is_barcode_available == false && number_tries < 7
      begin
        number_tries += 1
        is_barcode_available = user.barcode_available_in_sierra?
        # wait a bit before hitting Sierra up again
      rescue Exceptions::InvalidResponse => e
        defensive_log("#{self.class.name}: user.check_barcode_uniqueness_with_sierra threw an error: #{e.message || 'nil'}")
        raise e
      end
    
      # Barcode is not available in sierra assign barcode to user
      # and call sierra again with latest barcode
      unless is_barcode_available
        defensive_log("#{self.class.name}: barcode [#{user.barcode}] was already in Sierra,
          calling user assign_barcode again. No.of retries number_tries #{number_tries}")
        user.assign_barcode(number_tries)
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
          # user.account_confirmed_email_to_user
          defensive_log("#{self.class.name}: Patron creator service ran. Saving user in MLN db.")
          user.save_as_complete!
        end
      rescue Exceptions::InvalidResponse => e
        defensive_log("#{self.class.name}: \
          send_request_to_patron_creator_service or user.save_as_complete threw: #{e.message || 'nil'}")
        raise e
      end
    else
      defensive_log("#{self.class.name}: UserBarcodeJob.perform: barcode_already_in_sierra still true")
    end
  end

  private

  def defensive_log(msg)
    return Delayed::Worker.logger.add(Logger::INFO, msg) if Delayed::Worker.logger.present?
  end
end
