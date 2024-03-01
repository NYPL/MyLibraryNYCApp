# frozen_string_literal: true

MyLibraryNYC::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false
  # config.cache_store = :memory_store

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local = false

  config.action_controller.perform_caching = false

  config.action_mailer.raise_delivery_errors = true

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin

  # Raise exception on mass assignment protection for Active Record models
  # config.active_record.mass_assignment_sanitizer = :strict

  # Log the query plan for queries taking more than this (works
  # with SQLite, MySQL, and PostgreSQL)
  # config.active_record.auto_explain_threshold_in_seconds = 0.5

  # Do not compress assets
  config.assets.compress = false

  # Expands the lines which load the assets
  config.assets.debug = true

  config.action_mailer.default_url_options = { :host => "#{ENV.fetch('MLN_INFO_SITE_HOSTNAME', nil)}:3000" }
  config.action_mailer.perform_deliveries = false
  config.api_only = false
  # config.middleware.use ActionDispatch::Cookies
  # config.middleware.use ActionDispatch::Session::CookieStore
  # config.middleware.insert_after(ActionDispatch::Cookies, ActionDispatch::Session::CookieStore)

  config.logger = Logger.new($stdout)
  config.logger.level = Logger::DEBUG

  # Turn off asset pipline information showing in logs
  config.assets.logger = true

  config.eager_load = false

  config.active_job.queue_adapter = :delayed_job
  
  config.exceptions_app = lambda do |env|
    ExceptionsController.action(:render_error).call(env)
  end

  config.assets.debug = true
  Delayed::Worker.logger = Rails.logger
end
