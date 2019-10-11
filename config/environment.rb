# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
MyLibraryNYC::Application.initialize!

Rails.logger = ActiveSupport::Logger.new("log/my-library-nyc-application.log")
