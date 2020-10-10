# frozen_string_literal: true

class FindAvailableUserBarcodeJob < ApplicationJob
  queue_as :default
  #discard_on ActiveJob::DeserializationError
  #discard_on Exceptions::ArgumentError do |job, error|
  #  puts "FindAvailableUserBarcodeJob: discarding #{job} on error:#{error}"
  #end

  around_perform :around_cleanup

  # retry_on CustomAppException # defaults to 3s wait, 5 attempts


  def perform(user: nil, **args)
    puts "FindAvailableUserBarcodeJob.perform"
    # perform code on its own thread
    Rails.logger.debug "#{self.class.name}: I'm performing my job with arguments: #{args.inspect}"
    puts "FindAvailableUserBarcodeJob.perform: user=#{user || 'nil'}"

    # if we got passed bad user data, ___
    if user.blank?
      puts "FindAvailableUserBarcodeJob.perform: raising an error"
      raise Exceptions::ArgumentError, "FindAvailableUserBarcodeJob called with nil user."
    end

    # TODO: this will cause an infinite loop on barcode found.
    # move the retrying to its own job hook
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
        # wait a bit before hitting Sierra up again
        sleep(5)
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



    # TODO
    # handle race conditions in case more than one server is processing users
    # or users are incrementing barcodes independently of each other without
    # locking table
  end


  rescue_from(Exceptions::InvalidResponse) do |exception|
    # Do something with the exception
    puts "I rescued from InvalidResponse, now what"
    retry_job queue: :low_priority
  end


  private
    def around_cleanup
      # Do something before perform
      yield
      # Do something after perform
    end
end
