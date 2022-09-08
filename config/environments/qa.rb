# frozen_string_literal: true

MyLibraryNYC::Application.configure do
  # host doesn't matter, it only matters that it exists (for dev and qa, for production it does matter)
  config.action_mailer.default_url_options = { host: ENV['MLN_INFO_SITE_HOSTNAME'] }
  config.action_mailer.perform_deliveries = true
  config.force_ssl = false
  config.consider_all_requests_local = false
  config.logger = ActiveSupport::Logger.new("log/my-library-nyc-application.log")
  config.logger.level = Logger::INFO
  
  # config.session_store :cookie_store, key: '_interslice_session'
  # config.middleware.use ActionDispatch::Cookies
  # config.middleware.use config.session_store, config.session_options

  config.hosts = [ENV['MLN_INFO_SITE_HOSTNAME'], ENV['MLN_SETS_SITE_HOSTNAME'],
                  ENV['MLN_ENVIRONMENT_URL'], ENV['MLN_API_GATEWAY_URL'],
                  "http://my-library-nyc-app-react-qa-27.unpc66pkwp.us-east-1.elasticbeanstalk.com",
                  "my-library-nyc-app-react-qa-27.unpc66pkwp.us-east-1.elasticbeanstalk.com"
                ]
  config.eager_load = true
end
