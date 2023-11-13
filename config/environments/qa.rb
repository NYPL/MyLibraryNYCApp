# frozen_string_literal: true

MyLibraryNYC::Application.configure do
  # host doesn't matter, it only matters that it exists (for dev and qa, for production it does matter)
  config.action_mailer.default_url_options = { host: ENV.fetch('MLN_INFO_SITE_HOSTNAME', nil) }
  config.action_mailer.perform_deliveries = true
  config.force_ssl = false
  config.consider_all_requests_local = false
  config.logger = ActiveSupport::Logger.new("log/my-library-nyc-application.log")
  config.logger = Logger.new($stdout)
  config.logger.level = Logger::INFO
  
  # config.session_store :cookie_store, key: '_interslice_session'
  # config.middleware.use ActionDispatch::Cookies
  # config.middleware.use config.session_store, config.session_options

  config.hosts = [
    ENV.fetch('MLN_INFO_SITE_HOSTNAME', nil), ENV.fetch('MLN_SETS_SITE_HOSTNAME', nil),
    ENV.fetch('MLN_ENVIRONMENT_URL', nil), ENV.fetch('MLN_API_GATEWAY_URL', nil),
    IPAddr.new('10.227.0.0/16'), # connection on private network for ECS target health check
    "http://my-library-nyc-app-react-qa-27.unpc66pkwp.us-east-1.elasticbeanstalk.com",
    "my-library-nyc-app-react-qa-27.unpc66pkwp.us-east-1.elasticbeanstalk.com",
    "qa-new-www.mylibrarynyc.org",
    "mylibrarynycapp-qa-456976389.us-east-1.elb.amazonaws.com"
  ]
  config.eager_load = true
  config.active_job.queue_adapter = :delayed_job
  Delayed::Worker.logger = Logger.new($stdout)
  Delayed::Worker.logger = Logger.new(File.join(Rails.root, 'log', 'delayed_job.log'))
end
