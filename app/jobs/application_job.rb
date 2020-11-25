# frozen_string_literal: true

class ApplicationJob < ActiveJob::Base
  # NOTE: Below ideas are great, and very recommended, but require
  # rails >= 5.2.  We keep these notes here as a reminder to revisit,
  # next time we upgrade our rails version.
  
  # Automatically retry jobs that encountered a deadlock
  # retry_on ActiveRecord::Deadlocked
  # Most jobs are safe to ignore if the underlying records are no longer available
  # discard_on ActiveJob::DeserializationError

end
