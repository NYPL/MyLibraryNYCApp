# frozen_string_literal: true

require 'test_helper'

class UserTests < ActiveSupport::TestCase
  include AwsDecrypt

  setup do
    # create the first user with a barcode in range so that send_request_to_patron_creator_service will work
    @user = crank(:queens_user, barcode: 27777011111111)
    SierraCodeZcodeMatch.create(sierra_code: 1, zcode: @user.school.code)
    AllowedUserEmailMasks.create(active:true, email_pattern: "@schools.nyc.gov")
    @pin_error = 'PIN/Password does not meet our requirements. PIN/Password should not contain common patterns. e.g. aaat4, abcabc. Please try again.'
  end

  [generate_barcode].each do |barcode|
    test 'sierra user can be found by barcode' do
      mock_check_barcode_request(barcode, '200')
      @user.barcode = barcode
      response = @user.barcode_available_in_sierra?
      user_would_be_unique_in_sierra = false
      assert_equal response, user_would_be_unique_in_sierra
    end

    test 'sierra user cannot be found by barcode' do
      mock_check_barcode_request(barcode, '404')
      @user.barcode = barcode
      response = @user.barcode_available_in_sierra?
      user_would_be_unique_in_sierra = true
      assert_equal response, user_would_be_unique_in_sierra
    end

    test 'multiple sierra users found' do
      mock_check_barcode_request(barcode, '409')
      @user.barcode = barcode
      response = @user.barcode_available_in_sierra?
      user_would_be_unique_in_sierra = false
      assert_equal response, user_would_be_unique_in_sierra
    end

    test 'sierra barcode lookup fails' do
      mock_check_barcode_request(barcode, '500')
      @user.barcode = barcode
      response = @user.barcode_available_in_sierra?
      user_would_be_unique_in_sierra = false
      assert_equal response, user_would_be_unique_in_sierra
    end

    test 'user model cannot be created without first name' do
      @user.first_name = ""
      @user.save
      assert_equal(["can't be blank", "is invalid"], @user.errors.messages[:first_name])
    end

    test 'user model cannot be created without last name' do
      @user.last_name = ""
      @user.save
      assert_equal(["can't be blank", "is invalid"], @user.errors.messages[:last_name])
    end
  end

  ## NOTE:  We manage allowed email addresses dynamically now, but schools.nyc.gov
  # is to always be allowed, and it's OK not to test registration success for the others.
  [generate_email_without_valid_domain].each do |new_email|
    test 'should not save user without schools.nyc.gov domain in email' do
      @user.email = "testing@gmail.com"
      @user.save
      assert_equal(["should end in @schools.nyc.gov or another participating school address"], @user.errors[:email])
    end
  end

  # Mock request being sent in test_helper.rb called
  # by mock_get_oauth_token_request
  test 'user method get_oauth_token is giving back an access token from
    ISSO NYPL service' do
    token = Oauth.get_oauth_token
    assert_not token.nil?
    assert token.present?
  end

  [generate_email].each do |new_email|
    test "user method get_email_records returns a 404 illustrating that
      e-mail hasn't been used yet by a patron" do
        mock_check_email_request(new_email)
        response = @user.get_email_records(new_email)
        expected_response = {
          'status' => 404,
          'type' => 'exception',
          'message' => 'No matching record found',
          'error' => [],
          'debugInfo' => []
        }
        assert_equal response, expected_response
      end
  end

  test "user method send_request_to_patron_creator_service returns
    a 201 illustrating patron was created through
      patron creator microservice" do
    crank(:queens_user, barcode: 27777011111111)
    assert_equal(206, @user.send_request_to_patron_creator_service(@user.password))
  end

  # Need to call twice, in order to receive the second response
  # in the mock_send_request_to_patron_creator_service
  # method which is a status code of 500
  test "user method send_request_to_patron_creator_service returns an exception illustrating patron was not created through patron creator micro-service" do
    @user.send_request_to_patron_creator_service(@user.password)
    exception = assert_raise(Exceptions::InvalidResponse) do
      @user.send_request_to_patron_creator_service(@user.password)
    end
    assert_equal('Invalid status code of: 500', exception.message)
  end

  test "Queens patron's patron_type is set based on their school's borough" do
    assert_equal(@user.patron_type, 149)
  end

  test "Bronx patron's patron_type is set based on their school's borough" do
    assert_equal(crank(:bronx_user).patron_type, 151)
  end

  test "Queens patron's pcode3 is set based on their school's borough" do
    assert_equal(crank(:queens_user).pcode3, 5)
  end

  test "Bronx patron's pcode3 is set based on their school's borough" do
    assert_equal(crank(:bronx_user).pcode3, 1)
  end

  test "Patron's pcode4 is set based on their school's sierra_code" do
    user = crank(:bronx_user)
    SierraCodeZcodeMatch.create(sierra_code: 1, zcode: user.school.code)
    assert_equal(user.pcode4, user.school.sierra_code)
  end
end
