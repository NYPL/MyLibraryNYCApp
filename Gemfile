# frozen_string_literal: true

ruby '2.5.7'

source 'https://rubygems.org'

# force pre-2.0 Bundler to use https on github
git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '5.0.7.1'
gem 'actionpack', '5.0.7.1'
gem 'activeadmin', '2.4.0'
gem 'activemodel', '5.0.7.1'
gem 'active_model_serializers', '~> 0.8.1'
gem 'addressable'
gem 'auto-session-timeout'
gem 'aws-sdk', '~> 3'
gem 'client_side_validations', '16.0.3'
gem 'cranky'
gem 'devise', '>= 4.4.3'
gem 'faker'
gem 'figaro'
gem 'font-awesome-rails'
gem 'httparty'
gem 'jquery-rails', '> 4.0'
gem 'jquery-ui-rails'
gem 'json'
gem "lograge"
gem "logstash-event"
gem 'nokogiri'
gem 'open_uri_redirections'
gem 'paper_trail', github: 'paper-trail-gem/paper_trail', branch: '5-stable'
gem 'pg', '~> 0.18'
gem 'rack-cors'
gem 'rubocop','~> 0.59.1', require: false
gem 'test-unit'
gem 'will_paginate', '~> 3.0'
gem 'webmock'
gem 'yaml_db'
gem 'rails-perftest', '~> 0.0.7'

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
  gem 'minitest', '~> 5.6.1'
  gem 'simplecov', '~> 0.12.0'
  gem 'database_cleaner'
end
