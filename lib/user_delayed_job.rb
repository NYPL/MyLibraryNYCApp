class UserDelayedJob < Struct.new(:user_id, :pin)

  def perform
    user = User.find(user_id)
    
    if user.blank?
      Delayed::Worker.logger.error("FindAvailableUserBarcodeJob called with nil user or pin.")
      raise Exceptions::ArgumentError, "FindAvailableUserBarcodeJob called with nil user or pin."
    end

    is_barcode_available = false
    
    number_tries = 0
    while is_barcode_available == false && number_tries < 7
      # ask the user to ask Platform Service to ask Sierra if it
      # already knows this barcode candidate
      begin
        number_tries += 1
        is_barcode_available = user.is_barcode_available_in_sierra
      rescue Exceptions::InvalidResponse => exception
        # Ideally, we would be logging the exception here, then re-raising,
        # so that the ActiveJob mechanism would take care of retrying.
        # However, such exception handling will become available to us once
        # we upgrade our rails version.  For now, go simpler.


        Delayed::Worker.logger.error("#{self.class.name}: user.check_barcode_uniqueness_with_sierra threw an error: #{exception.message || 'nil'}")
        raise exception
      end
    end

    # We tried to find a unique barcode, coordinating our actions with sierra.
    # If we succeeded, it's time to tell the User object that its barcode is no longer pending
    if is_barcode_available == true
      begin
        Delayed::Worker.logger.info("#{self.class.name}: barcode [#{user.password}] is available in Sierra, calling patron creator service.")

        # TODO: on timeouts/exceptions/negative results,
        # don't send request to Patron Service, keep user as pending
        user.send_request_to_patron_creator_service(pin)

        Delayed::Worker.logger.info("#{self.class.name}: Patron creator service ran. Saving user in MLN db.")
        user.save_as_complete!
      rescue Exceptions::InvalidResponse => exception
        # Ideally, we would be logging the exception here, then re-raising, so that the ActiveJob mechanism
        # would take care of retrying.  However, such exception handling will not become available to us
        # until we upgrade our rails version.  For now, go simpler - log, and squash in our own rescue_from method below.
        Delayed::Worker.logger.error("#{self.class.name}: \
          send_request_to_patron_creator_service or user.save_as_complete threw: #{exception.message || 'nil'}")
        raise exception
      end
    else
      # TODO: Decide on action.  We can let this go by silently.
      # In that case, the user's record will exist in MLN db with the status
      # of "pending", and there will be no Sierra record made.  The user will
      # not know there was a problem.  BookOps will need to deal with this on
      # checkout, or Libraries Outreach will need to run a periodic check of
      # incomplete user records to manually correct.
      # Alternatively, we could show an error message to the user, or send an
      # email to MLN help address.
      Delayed::Worker.logger.info("#{self.class.name}: FindAvailableUserBarcodeJob.perform: barcode_already_in_sierra still true")
    end
  end
end