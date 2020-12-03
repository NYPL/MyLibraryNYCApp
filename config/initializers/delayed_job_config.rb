# frozen_string_literal: true

require 'find_available_user_barcode_job'

# keep failed jobs in the database, so can troubleshoot later
Delayed::Worker.destroy_failed_jobs = false

# TODO: in production, this needs to be increased to at least a couple of minutes
Delayed::Worker.sleep_delay = 30
# TODO: in production, increase to 12
Delayed::Worker.max_attempts = 3

# If worker takes longer than X time, kill the delayed worker,
# and allow the job to fail so another worker can pick it up.
# Also, allows for notifications for over-long tasks
# (via email notifications on error and failure hooks).
Delayed::Worker.max_run_time = 15.minutes

Delayed::Worker.read_ahead = 10

Delayed::Worker.default_queue_name = 'default'


# don't run delayed_job in test mode
Delayed::Worker.delay_jobs = !Rails.env.test?

# You may need to raise exceptions on SIGTERM signals.
# raise_signal_exceptions = :term will cause the worker to raise a SignalException, causing the
# running job to abort and be unlocked, which makes the job available to other workers.
Delayed::Worker.raise_signal_exceptions = :term


# Delayed::Worker.queue_attributes = {
#  default_high_priority: { priority: -10 },
#  default_low_priority: { priority: 10 },
#  barcode_queue: { priority: 10 }
# }

Delayed::Worker.logger = Logger.new(File.join(Rails.root, 'log', 'delayed_job.log'))
