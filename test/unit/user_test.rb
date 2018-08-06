require 'test_helper'

class UserTest < ActiveSupport::TestCase
  include AwsDecrypt

  # Create sample test data
  first_name = Faker::Name.first_name
  last_name = Faker::Name.last_name
  email = generate_email
  pin = [1, 1, 1, 1].map! { (0..9).to_a.sample }.join
  school_id = '1076'
  password = 'password123'

  setup do 
   @user = crank(:user)
  end 

  [generate_email].each do |new_email|
    test 'user model cannot be created without first name' do
      @user.first_name = ""
      @user.save 
      assert_equal(@user.errors.messages[:first_name],["can't be blank", "is invalid"])
    end
  end

  [generate_email].each do |new_email|
    test 'user model cannot be created without last name' do
      @user.last_name = ""
      @user.save
      assert_equal(@user.errors.messages[:last_name],["can't be blank", "is invalid"])
    end
  end

  [generate_email].each do |new_email|
    test 'user model cannot be created without pin' do
      @user.pin = ""
      @user.save
      assert_equal(@user.errors.messages[:pin],["can't be blank", "requires numbers only.", "must be 4 digits."])
    end
  end

  [generate_email_without_valid_domain].each do |new_email|
    test 'should not save user without schools.nyc.gov domain in email' do
      @user.email = "testing@gmail.com"
      @user.save
      assert_equal(@user.errors[:email],[" should end in @schools.nyc.gov"])
    end
  end

  # Mock request being sent in test_helper.rb called
  # by mock_get_oauth_token_request
  test 'user method get_oauth_token is giving back an access token from
    ISSO NYPL service' do
    token = @user.get_oauth_token
    assert !token.nil?
    assert token.present?
  end

  [generate_email].each do |new_email|
    test "user method get_email_records returns a 404 illustrating that
      e-mail hasn't been used yet by a patron" do
        mock_check_email_request(new_email)
        response = @user.get_email_records(new_email)
        expected_response = {
          'statusCode' => 404,
          'type' => 'exception',
          'message' => 'No matching record found',
          'error' => [],
          'debugInfo' => []
        }
        assert response == expected_response
      end
  end

  test "user method send_request_to_patron_creator_service returns
    a 201 illustrating patron was created through
      patron creator microservice" do
    assert_true @user.send_request_to_patron_creator_service
  end

  # Need to call twice, in order to receive the second response
  # in the mock_send_request_to_patron_creator_service
  # method which is a status code of 500
  test "user method send_request_to_patron_creator_service returns
    an exception illustrating patron was not created
      through patron creator micro-service" do
    @user.send_request_to_patron_creator_service
    exception = assert_raise(Exceptions::InvalidResponse) do
      @user.send_request_to_patron_creator_service
    end
    assert_equal('Invalid status code of: 500', exception.message)
  end
end
