ruby '2.2.10'

source 'https://rubygems.org'
gem 'rails', '3.2.22.5'
gem 'activeadmin', '0.6.6.1', github: 'nypl/activeadmin'
gem 'active_model_serializers', '~> 0.8.1'
gem 'addressable'
gem 'auto-session-timeout'
gem 'aws-sdk'
gem 'client_side_validations'
gem 'cranky'
gem 'devise'
gem 'faker'
gem 'figaro'
gem 'font-awesome-rails'
gem 'httparty'
gem 'jquery-rails', '< 3.0.0'
gem 'json'
gem 'meta_search', '>= 1.1.0.pre'
gem 'nokogiri'
gem 'open_uri_redirections'
gem 'paper_trail', github: 'paper-trail-gem/paper_trail', branch: '5-stable'
gem 'pg', '~> 0.18'
gem 'rubocop'
gem 'sendgrid-ruby', '~> 1.1.6'
gem 'test-unit'
gem 'will_paginate', '~> 3.0'
gem 'webmock'
gem 'yaml_db'
gem "lograge"
gem "logstash-event"
gem 'rack-cors'
gem 'minitest', '~> 5.6.1'

group :assets do # Gems used only for assets and not required in production environments by default.
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'therubyracer', :platforms => :ruby # https://github.com/sstephenson/execjs#readme for more supported runtimes for ExecJS
  gem 'uglifier', '>= 1.0.3'
end

group :development, :local do
  gem 'pry', '>= 0.10.0'
	gem 'pry-rails'
  gem 'pry-remote'
  gem 'pry-nav', '>= 0.2.4'
  gem 'pry-rescue'
end

group :test do
  gem 'database_cleaner'
end
