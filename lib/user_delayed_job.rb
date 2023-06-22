class UserDelayedJob < Struct.new(:user_id, :pin)

  def perform
    user = User.find(user_id)
    
    if user.blank?
      Delayed::Worker.logger.error("FindAvailableUserBarcodeJob called with nil user or pin.")
      raise Exceptions::ArgumentError, "FindAvailableUserBarcodeJob called with nil user or pin."
    end

    is_barcode_available = false
    
    number_tries = 0;
    while is_barcode_available == false && number_tries < 7
      begin
        number_tries += 1
        is_barcode_available = user.is_barcode_available_in_sierra
      rescue Exceptions::InvalidResponse => exception
        Delayed::Worker.logger.error("#{self.class.name}: user.check_barcode_uniqueness_with_sierra threw an error: #{exception.message || 'nil'}")
        raise exception
      end
    end

    if is_barcode_available == true
      begin
        Delayed::Worker.logger.info("#{self.class.name}: barcode [#{user.password}] is available in Sierra, calling patron creator service.")
        response = user.send_request_to_patron_creator_service(pin)
        if response.code == 201
          Delayed::Worker.logger.info("Patron created successfully")
          # Send email to user
          user.account_confirmed_email_to_user
        end
        Delayed::Worker.logger.info("#{self.class.name}: Patron creator service ran. Saving user in MLN db.")
        user.save_as_complete!
      rescue Exceptions::InvalidResponse => exception
        Delayed::Worker.logger.error("#{self.class.name}: \
          send_request_to_patron_creator_service or user.save_as_complete threw: #{exception.message || 'nil'}")
        raise exception
      end
    else
      Delayed::Worker.logger.info("#{self.class.name}: FindAvailableUserBarcodeJob.perform: barcode_already_in_sierra still true")
    end
  end
end