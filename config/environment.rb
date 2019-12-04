# frozen_string_literal: true

# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
MyLibraryNYC::Application.initialize!

Rails.logger = Logger.new(STDOUT)
Rails.logger.level = Logger::DEBUG
