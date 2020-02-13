# frozen_string_literal: true

MyLibraryNYC::Application.configure do
  # host doesn't matter, it only matters that it exists (for dev and qa, for production it does matter)
  config.action_mailer.default_url_options = { host:  'my-library-nyc-app-qa.us-east-1.elasticbeanstalk.com' }
  config.action_mailer.perform_deliveries = true

  config.force_ssl = false
  #When enabled, an exception is raised for missing assets. This option is enabled by default.
  config.assets.check_precompiled_asset = true
  config.logger = ActiveSupport::Logger.new("log/my-library-nyc-application.log")
  config.logger.level = Logger::INFO
end
