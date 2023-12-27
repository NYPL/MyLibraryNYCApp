# frozen_string_literal: true

ruby '2.7.4'

source 'https://rubygems.org'

# force pre-2.0 Bundler to use https on github
git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'delayed_job'
gem 'delayed_job_active_record'
gem 'daemons'

gem "minitest-stub_any_instance"
gem 'rails', '6.1.4.1'
gem 'actionpack', '6.1.4.1'
gem 'actioncable', '6.1.4.1'
gem 'activeadmin', '~> 2.14'
gem 'actionmailer', '6.1.4.1'
gem 'activeadmin_reorderable'
gem 'activemodel', '6.1.4.1'
gem 'activejob', '6.1.4.1'
gem 'activerecord', '6.1.4.1'
gem 'activestorage', '6.1.4.1'
gem 'activesupport', '6.1.4.1'
gem 'active_model_serializers', '~> 0.8.1'
gem 'acts_as_list'
gem 'addressable'
gem 'auto-session-timeout'
gem 'actionview', '6.1.4.1'
gem 'aws-sdk', '~> 3'
gem 'client_side_validations', '17.2.0'
gem 'cranky'
gem 'devise', '4.8.1'
gem 'elasticsearch', '6.8'
gem 'email_validator'
gem 'faker'
gem 'figaro'
gem 'font-awesome-rails'
gem 'railties', '~> 6.1.4.1'
gem 'google-api-client'
gem 'google_drive'
gem 'httparty'
gem 'json'
gem 'lograge', '~> 0.11.2'
gem 'logstash-event', github: 'elastic/logstash', tag: 'v1.5.4'
gem 'nokogiri'
gem 'open_uri_redirections'
gem 'paper_trail', '~> 11.1'
gem 'pg', '~> 1.2'
gem 'rack-cors'
gem 'rails-controller-testing'
gem 'rubocop','~> 1.48', require: false
gem 'test-unit'
gem 'travis'
gem 'will_paginate', '~> 3.0'
gem 'webmock'
gem 'yaml_db'
gem 'rexml', '~> 3.2.5'
gem 'rubocop-performance', '~> 1.16'
gem 'thread_safe', '~> 0.3.6'
gem "react_on_rails", "12.0.0"
gem "webpacker", "~> 5"
gem "breakpoint", "~>2.4.0"
gem 'execjs'
gem 'therubyracer', :platforms => :ruby
gem 'bcrypt'
gem 'puma', '~> 5.5'
gem 'activeadmin_addons', '~> 1.9'
gem 'turbolinks', '~> 5.2.0'
gem 'rack', '~> 2.2.4'
gem "jsonapi-serializer"

group :assets do # Gems used only for assets and not required in production environments by default.
  gem 'sass-rails'
  gem 'coffee-rails'
  gem 'uglifier', '>= 1.0.3'
end

group :development, :local do
  gem 'pry', '>= 0.10.0'
  gem 'pry-rails'
  gem 'pry-remote'
  gem 'pry-nav', '>= 0.2.4'
  gem 'pry-rescue'
  gem 'pry-stack_explorer'
end

group :test do
  gem 'minitest', '~> 5.14.2'
  gem 'simplecov', '~> 0.17.1'
  gem 'database_cleaner'
end
