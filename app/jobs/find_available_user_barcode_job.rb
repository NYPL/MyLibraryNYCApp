# frozen_string_literal: true

# Asynchronously calls User methods to find a new barcode that
# would be available in both MLN db and Sierra.
class FindAvailableUserBarcodeJob < ApplicationJob
  queue_as :user_barcode_queue

  # NOTE: retry_on and discard_on need rails >= 5.1.
  # TODO: Update rails, and replace current retry handling with built-in hooks.

  around_perform :around_cleanup


  def perform(user: nil, **args)
    puts "FindAvailableUserBarcodeJob.perform"
    # perform code on its own thread
    Rails.logger.debug "#{self.class.name}: Performing FindAvailableUserBarcodeJob with user: #{user || 'nil'} arguments: #{args.inspect || 'nil'}"
    puts "FindAvailableUserBarcodeJob.perform: user=#{user || 'nil'}"

    # if we got passed bad user data, something un-recoverably bad is possibly happening
    if user.blank?
      puts "FindAvailableUserBarcodeJob.perform: raising an error"
      raise Exceptions::ArgumentError, "FindAvailableUserBarcodeJob called with nil user."
    end

    # TODO: this will cause an infinite loop on barcode found.
    # move the retrying to its own job hook
    # TODO: stop on barcode out of available range
    already_there = true
    # Number of retries should ideally be controlled by ActiveJob/DelayedJob config.
    # However, this works better until next rail upgrade.
    number_tries = 0
    while already_there == true and number_tries < 7 do
      # ask the user to ask Platform Service to ask Sierra if it
      # already knows this barcode candidate
      puts "FindAvailableUserBarcodeJob.perform: about to call user.check_barcode_uniqueness_with_sierra"
      begin
        already_there = user.check_barcode_uniqueness_with_sierra(user.barcode)
        number_tries += 1
      rescue Exceptions::InvalidResponse => exception
        # Ideally, we would be logging the exception here, then re-raising,
        # so that the ActiveJob mechanism would take care of retrying.
        # However, such exception handling will become available to us once
        # we upgrade our rails version.  For now, go simpler.
        puts "re-raising #{exception.message}"
        Rails.logger.error "#{self.class.name}: user.check_barcode_uniqueness_with_sierra threw an error: #{exception.message || 'nil'}"
        raise exception
      end

      puts "FindAvailableUserBarcodeJob.perform: called user.check_barcode_uniqueness_with_sierra, already_there=#{already_there}"
      already_there = true;  # TODO: REMOVE ME

      # barcode found to already be in Sierra for another user?
      # well, we can't be saving this user with a duplicate barcode.
      # ask the user to increment its barcode, and try again.
      if already_there
        puts "FindAvailableUserBarcodeJob.perform: barcode was in sierra, calling user.assign_barcode, user.barcode=#{user.barcode}"
        Rails.logger.debug "#{self.class.name}: barcode [#{user.barcode}] was already in Sierra, calling user.assign_barcode again"
        user.assign_barcode!
        puts "FindAvailableUserBarcodeJob.perform: called user.assign_barcode, user.barcode=#{user.barcode}"
        # wait a bit before hitting Sierra up again
        sleep(20)
      end
    end

    # We tried to find a unique barcode, coordinating our actions with sierra.
    # If we succeeded, it's time to tell the User object that its barcode is no longer pending
    if already_there == false
      begin
        puts "FindAvailableUserBarcodeJob.perform: calling send_request_to_patron_creator_service"
        Rails.logger.debug "#{self.class.name}: barcode [#{user.barcode}] is available in Sierra, calling patron creator service."

        # TODO: on timeouts/exceptions/negative results,
        # don't send request to Patron Service, keep user as pending
        user.send_request_to_patron_creator_service

        puts "\n\nRegistrationsController.create: calling user.save_as_complete"
        Rails.logger.debug "#{self.class.name}: Patron creator service ran. Saving user in MLN db."
        user.save_as_complete!
        puts "RegistrationsController.create: done user.save_as_complete"
      rescue Exceptions::InvalidResponse => exception
        # Ideally, we would be logging the exception here, then re-raising,
        # so that the ActiveJob mechanism would take care of retrying.
        # However, such exception handling will become available to us once
        # we upgrade our rails version.  For now, go simpler.
        puts "re-raising #{exception.message}"
        Rails.logger.error "#{self.class.name}: user.send_request_to_patron_creator_service or user.save_as_complete! threw an error: #{exception.message || 'nil'}"
        raise exception
      end
    else
      # FindAvailableUserBarcodeJob.perform: already_there still true

      # TODO: Decide on action.  We can let this go by silently.
      # In that case, the user's record will exist in MLN db with the status
      # of "pending", and there will be no Sierra record made.  The user will
      # not know there was a problem.  BookOps will need to deal with this on
      # checkout, or Libraries Outreach will need to run a periodic check of
      # incomplete user records to manually correct.
      # Alternatively, we could show an error message to the user, or send an
      # email to MLN help address.
    end



    # TODO
    # handle race conditions in case more than one server is processing users
    # or users are incrementing barcodes independently of each other without
    # locking table
  end


  rescue_from Exception do |exception|
    puts "I rescued from Exception, now what"
  end



  private
    def around_cleanup
      # Do something before perform
      yield
      # Do something after perform
    end
end
