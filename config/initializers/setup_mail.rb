# frozen_string_literal: true

ActionMailer::Base.delivery_method = :smtp	

ActionMailer::Base.smtp_settings = {	
  address: 'email-smtp.us-east-1.amazonaws.com',
  port: '587',	
  authentication: :plain,	
  user_name: ENV.fetch('SMTP_USERNAME', nil),	
  password: ENV.fetch('SMTP_PASSWORD', nil),	
  domain: 'mylibrarynyc.org',	
}
