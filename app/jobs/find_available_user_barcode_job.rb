# frozen_string_literal: true

# Asynchronously calls User methods to find a new barcode that
# would be available in both MLN db and Sierra.
class FindAvailableUserBarcodeJob < ApplicationJob
  queue_as :default

  # NOTE: retry_on and discard_on need rails >= 5.1.
  # TODO: Update rails, and replace current retry handling with built-in hooks.

  around_perform :around_cleanup


  def perform(user: nil, **args)
    puts "FindAvailableUserBarcodeJob.perform"
    # perform code on its own thread
    Rails.logger.debug "#{self.class.name}: Performing FindAvailableUserBarcodeJob with user: #{user || 'nil'} arguments: #{args.inspect || 'nil'}"
    puts "FindAvailableUserBarcodeJob.perform: user=#{user || 'nil'}"

    # if we got passed bad user data, ___
    if user.blank?
      puts "FindAvailableUserBarcodeJob.perform: raising an error"
      raise Exceptions::ArgumentError, "FindAvailableUserBarcodeJob called with nil user."
    end

    # TODO: this will cause an infinite loop on barcode found.
    # move the retrying to its own job hook
    # TODO: stop on barcode out of available range
    already_there = true
    while already_there == true do
      # ask the user to ask Platform Service to ask Sierra if it
      # already knows this barcode candidate
      puts "FindAvailableUserBarcodeJob.perform: about to call user.check_barcode_found_in_sierra"
      begin
        already_there = user.check_barcode_found_in_sierra(user.barcode)
      rescue Exceptions::InvalidResponse => exception
        puts exception.message
        #puts "re-raising"
        #raise Exceptions::InvalidResponse, "RAISE EXCEPTION AGAIN TO RETRY"
        #puts "re-rais-ed"
      end
      puts "re-raising"
      raise StandardError.new("This is the error message")
      puts "re-raised"

      try next: run in server, see if rescue_from works when job is run in daemon

      puts "FindAvailableUserBarcodeJob.perform: called user.check_barcode_found_in_sierra, already_there=#{already_there}"

      # barcode found to already be in Sierra for another user?
      # well, we can't be saving this user with a duplicate barcode.
      # ask the user to increment its barcode, and try again.
      if already_there
        puts "FindAvailableUserBarcodeJob.perform: barcode was in sierra, calling user.assign_barcode, user.barcode=#{user.barcode}"
        user.assign_barcode!
        puts "FindAvailableUserBarcodeJob.perform: called user.assign_barcode, user.barcode=#{user.barcode}"
        # wait a bit before hitting Sierra up again
        sleep(5)
      end
    end

    # We tried to find a unique barcode, coordinating our actions with sierra.
    # If we succeeded, it's time to tell the User object that its barcode is no longer pending
    if already_there == false
      puts "FindAvailableUserBarcodeJob.perform: calling user.save_as_complete"
      # TODO: move saving as complete to end of send_request_to_patron_creator_service
      user.save_as_complete!
      puts "FindAvailableUserBarcodeJob.perform: done user.save_as_complete"
    else
      # todo
      puts "FindAvailableUserBarcodeJob.perform: already_there still true"
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
