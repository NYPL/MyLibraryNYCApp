# frozen_string_literal: true

class UserDelayedJob < Struct.new(:user_id, :pin)
  def perform
    user = User.find(user_id)

    if user.blank?
      defensive_log("UserBarcodeJob called with nil user or pin.")
      raise Exceptions::ArgumentError, "UserBarcodeJob called with nil user or pin."
    end

    is_username_available = false
    number_tries = 0
    # username already found in Sierra for another user?
    # well, we can't be saving this user with a duplicate username.
    # ask the user to increment the username, and try again.
    while is_username_available == false && number_tries < 7
      begin
        number_tries += 1
        is_username_available, user_name = user.username_available_in_sierra?
        # wait a bit before hitting Sierra up again
      rescue Exceptions::InvalidResponse => e
        defensive_log("#{self.class.name}: user.check_username_uniqueness_with_sierra threw an error: #{e.message || "nil"}")
        raise e
      end

      # Barcode is not available in sierra assign barcode to user
      # and call sierra again with latest barcode
      unless is_username_available
        defensive_log("#{self.class.name}: barcode [#{user.barcode}] was already in Sierra,
          calling user assign_username again. No.of retries number_tries #{number_tries}")
        is_username_available, user_name = user.username_available_in_sierra?
        sleep(60)
      end
    end
    if is_username_available == true
      begin
        defensive_log("#{self.class.name}: barcode [#{user.barcode}] is available in Sierra, calling patron creator service.")
        response = user.invoke_patron_create_service(pin, user_name)

        if response.code == 200
          defensive_log("Patron created successfully")
          # Send user account confirmation email
          user.account_confirmed_email_to_user
          defensive_log("#{self.class.name}: Patron creator service ran. Saving user in MLN db.")
          user.save_as_complete!
        end
      rescue Exceptions::InvalidResponse => e
        defensive_log("#{self.class.name}: \
          invoke_patron_create_service or user.save_as_complete threw: #{e.message || "nil"}")
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
