# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
MyLibraryNYC::Application.initialize!

Rails.logger = NyplLogFormatter.new("log/test.log")
