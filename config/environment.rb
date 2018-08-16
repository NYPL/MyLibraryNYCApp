# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
MyLibraryNYC::Application.initialize!

mylibarynyc_log = ActiveSupport::BufferedLogger.new("log/my-library-nyc-application.log")
MyLibraryNYC::Application = mylibarynyc_log
