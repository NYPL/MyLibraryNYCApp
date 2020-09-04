# frozen_string_literal: true

class FindAvailableUserBarcodeJob < ApplicationJob
  queue_as :default

  around_perform :around_cleanup

  # retry_on CustomAppException # defaults to 3s wait, 5 attempts
  # discard_on ActiveJob::DeserializationError


  def perform(user: nil, **args)
    puts "FindAvailableUserBarcodeJob.perform"
    # perform code on its own thread
    Rails.logger.debug "#{self.class.name}: I'm performing my job with arguments: #{args.inspect}"
    puts "FindAvailableUserBarcodeJob.perform: user=#{user}"

    # TODO: handle user == nil

    # TODO: this will cause an infinite loop.  move the retrying to its own job hook
    already_there = true
    while already_there == true do
      # ask the user to ask Platform Service to ask Sierra if it
      # already knows this barcode candidate
      puts "FindAvailableUserBarcodeJob.perform: about to call user.check_barcode_found_in_sierra"
      already_there = user.check_barcode_found_in_sierra(user.barcode)
      puts "FindAvailableUserBarcodeJob.perform: called user.check_barcode_found_in_sierra, already_there=#{already_there}"

      # barcode found to already be in Sierra for another user?
      # well, we can't be saving this user with a duplicate barcode.
      # ask the user to increment its barcode, and try again.
      if already_there
        puts "FindAvailableUserBarcodeJob.perform: barcode was in sierra, calling user.assign_barcode, user.barcode=#{user.barcode}"
        user.assign_barcode
        puts "FindAvailableUserBarcodeJob.perform: called user.assign_barcode, user.barcode=#{user.barcode}"
      end
    end

    # We tried to find a unique barcode, coordinating our actions with sierra.
    # If we succeeded, it's time to tell the User object that its barcode is no longer pending
    if already_there == false
      puts "FindAvailableUserBarcodeJob.perform: calling user.save_as_complete"
      user.save_as_complete
      puts "FindAvailableUserBarcodeJob.perform: done user.save_as_complete"
    else
      # todo
      puts "FindAvailableUserBarcodeJob.perform: already_there still true"
    end



    # TODO handle exceptions
    # if might raise exceptions, like CustomAppException or
    # ActiveJob::DeserializationError, then can rescue or discard

    # TODO
    # handle race conditions in case more than one server is processing users
    # or users are incrementing barcodes independently of each other without
    # locking table
  end


  rescue_from(ActiveRecord::RecordNotFound) do |exception|
    # Do something with the exception
    # TODO
  end


  private
    def around_cleanup
      # Do something before perform
      yield
      # Do something after perform
    end
end
