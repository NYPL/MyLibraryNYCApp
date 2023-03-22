# frozen_string_literal: true

require 'poke_model_1_job'

# keep failed jobs in the database, so can troubleshoot later
Delayed::Worker.destroy_failed_jobs = false

Delayed::Worker.sleep_delay = 60
Delayed::Worker.max_attempts = 3

# If worker takes longer than X time, kill the delayed worker,
# and allow the job to fail so another worker can pick it up.
# Also, allows for notifications for over-long tasks
# (via email notifications on error and failure hooks).
Delayed::Worker.max_run_time = 5.minutes

Delayed::Worker.read_ahead = 10

Delayed::Worker.default_queue_name = 'default'


# don't run delayed_job in test mode
Delayed::Worker.delay_jobs = !Rails.env.test?

Delayed::Worker.raise_signal_exceptions = :term


# Delayed::Worker.queue_attributes = {
#  default_high_priority: { priority: -10 },
#  default_low_priority: { priority: 10 },
#  barcode_queue: { priority: 10 }
# }

Delayed::Worker.logger = Logger.new(Rails.root.join('log', 'delayed_job.log'))
