# frozen_string_literal: true

require 'user_delayed_job'

#queue_as :user_barcode_queue

# keep failed jobs in the database, so can troubleshoot later
Delayed::Worker.destroy_failed_jobs = false

Delayed::Worker.sleep_delay = 30
Delayed::Worker.max_attempts = 5

# If worker takes longer than X time, kill the delayed worker,
# and allow the job to fail so another worker can pick it up.
# Also, allows for notifications for over-long tasks
# (via email notifications on error and failure hooks).
Delayed::Worker.max_run_time = 10.minutes

Delayed::Worker.read_ahead = 10

Delayed::Worker.default_queue_name = 'user_barcode_queue'


# don't run delayed_job in test mode
Delayed::Worker.delay_jobs = !Rails.env.test?

Delayed::Worker.raise_signal_exceptions = :term


# Delayed::Worker.queue_attributes = {
#  default_high_priority: { priority: -10 },
#  default_low_priority: { priority: 10 },
#  barcode_queue: { priority: 10 }
# }

Delayed::Worker.logger = Rails.logger
Delayed::Worker.logger = Logger.new(File.join(Rails.root, 'log', 'delayed_job.log'))

