# frozen_string_literal: true

class ApplicationJob < ActiveJob::Base
  # Automatically retry jobs that encountered a deadlock
  # retry_on ActiveRecord::Deadlocked

  # Most jobs are safe to ignore if the underlying records are no longer available
  # discard_on ActiveJob::DeserializationError


  # doesn't seem to work with handle_asynchronously
  def after_perform
    puts "ApplicationJob.after_perform"
    #self.retry_delay = 60
  end


  # doesn't seem to work with handle_asynchronously
  def reschedule_at(current_time, attempts)
    puts "ApplicationJob.reschedule_at"
    #current_time + (60.seconds * attempts)
    #current_time + retry_delay.seconds
  end

  # doesn't work -- doesn't get called from a handle_asynchronously job
  #def initialize(user_id:, building_ids:, **_args)
  def initialize(**args)
    puts "ApplicationJob.initialize"
    #self.retry_delay = 5 # default retry delay
  end

  # doesn't work -- doesn't get called from a handle_asynchronously job
  def error(job, exception)
    puts "ApplicationJob.error"
    # set up a different the delay time on a specific error
    #if exception.is_a? NameError
    #self.retry_delay = 60
    #end
  end
end
