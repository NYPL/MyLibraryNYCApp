MyLibraryNYC::Application.configure do
  # host doesn't matter, it only matters that it exists (for dev and qa, for production it does matter)

  config.action_mailer.smtp_settings = {
   :port =>           '587',
   :address =>        'email-smtp.us-east-1.amazonaws.com',
   :user_name =>      ENV['SMTP_USERNAME'],
   :password =>       ENV['SMTP_PASSWORD'],
   :domain =>         'mylibrarynyc.org',
   :authentication => :plain
  }

  config.action_mailer.default_url_options = { host:  'my-library-nyc-app-qa.us-east-1.elasticbeanstalk.com' }
  config.action_mailer.perform_deliveries = true

  config.force_ssl = true

  Rails.env = 'qa'
end
