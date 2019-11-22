# frozen_string_literal: true

ActionMailer::Base.delivery_method = :smtp	

ActionMailer::Base.smtp_settings = {	
  address:        'email-smtp.us-east-1.amazonaws.com',
  port:           '587',	
  authentication: :plain,	
  user_name:      ENV['SMTP_USERNAME'],	
  password:       ENV['SMTP_PASSWORD'],	
  domain:         'mylibrarynyc.org',	
}
