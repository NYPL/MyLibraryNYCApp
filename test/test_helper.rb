ENV['RAILS_ENV'] = 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'webmock/test_unit'
require 'factories/user_factory'
require 'factories/school_factory'
require 'factories/book_factory'
require 'factories/teacher_set_factory'

include WebMock::API

WebMock.disable_net_connect!(allow_localhost: true)


class ActionController::TestCase
  include Devise::TestHelpers
end

class ActiveSupport::TestCase
  setup :mock_get_oauth_token_request, :mock_send_request_to_patron_creator_service

  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  # Add more helper methods to be used by all tests here...

  # generate_email returns a string with 8 random charachters concatenated with the current timestamp
  # and domain schools.nyc.gov
  def self.generate_email
    return ('a'..'z').to_a.shuffle[0, 8].join + Time.now.to_i.to_s + '@schools.nyc.gov'
  end

  # generate_email returns a string with 8 random charachters concatenated with the current timestamp
  # and domain gmail.com
  def self.generate_email_without_valid_domain
    return ('a'..'z').to_a.shuffle[0, 8].join + Time.now.to_i.to_s + '@gmail.com'
  end

  # mock_get_oauth_token_request mocks an https request to 'https://isso.nypl.org/oauth/token'
  # and returns a JSON object with the key access_token
  def mock_get_oauth_token_request
    stub_request(:post, 'https://isso.nypl.org/oauth/token')
      .to_return(status: 200, body: { 'access_token' => 'testoken' }.to_json)
  end

  # mock_check_email_request takes in a parameter of e-mail and mocks an https
  # request to 'https://dev-platform.nypl.org/api/v0.1/patrons?email=' and returns a
  # 404 statusCode if the e-mail hasn't been created in Sierra.
  # TODO: Need to add 200 if the e-mail has been created
  def mock_check_email_request(email)
    stub_request(:get, 'https://dev-platform.nypl.org/api/v0.1/patrons?email=' +
    email)
      .to_return(status: 200, body: {
        'status' => 404,
        'type' => 'exception',
        'message' => 'No matching record found',
        'error' => [],
        'debugInfo' => []
      }
      .to_json, headers: { 'Content-Type' => 'application/json' })
  end

  # mock_send_request_to_patron_creator_service sends an https request
  # to 'https://dev-platform.nypl.org/api/v0.2/patrons' and returns a
  # status of success if Sierra API created a patron record.
  def mock_send_request_to_patron_creator_service
    stub_request(:post, 'https://dev-platform.nypl.org/api/v0.2/patrons')
      .to_return({status: 201, body: {
        'status' => 'success'
      }
      .to_json, headers: {}},
      {status: 500, body: {
        'status' => 'failure'
      }
      .to_json, headers: {}}
      )
  end

end

begin
  puts "Starting test run..."

  puts "Starting DatabaseCleaner..."
  DatabaseCleaner.strategy = :truncation
  DatabaseCleaner.start
ensure
  puts "Cleaning up with DatabaseCleaner..."
  DatabaseCleaner.clean
end
