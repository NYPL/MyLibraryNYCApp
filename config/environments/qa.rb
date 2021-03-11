# frozen_string_literal: true

MyLibraryNYC::Application.configure do
  # host doesn't matter, it only matters that it exists (for dev and qa, for production it does matter)
  config.action_mailer.default_url_options = { host: ENV['MLN_INFO_SITE_HOSTNAME'] }
  config.action_mailer.perform_deliveries = true

  config.force_ssl = false
  config.hosts = [ENV['MLN_INFO_SITE_HOSTNAME'], ENV['MLN_SETS_SITE_HOSTNAME']]
  config.logger = ActiveSupport::Logger.new("log/my-library-nyc-application.log")
  config.logger.level = Logger::INFO

  config.eager_load = true
end
