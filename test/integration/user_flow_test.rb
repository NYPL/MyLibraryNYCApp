# frozen_string_literal: true

require 'test_helper'

class UserFlowTest < ActionDispatch::IntegrationTest
  test "user method assign_barcode increments last valid barcode by 1" do
    AllowedUserEmailMasks.create(active:true, email_pattern: "@schools.nyc.gov")
    user_one = crank!(:user, barcode: Integer(ENV['USER_BARCODE_ALLOTTED_RANGE_MINIMUM']))
    user_two = crank(:user)
    user_two.assign_barcode!
    assert(user_two.barcode == Integer(ENV['USER_BARCODE_ALLOTTED_RANGE_MINIMUM']) + 1)
  end


  [generate_email].each do |new_email|
    test 'create new user record and send request to microservice' do
      AllowedUserEmailMasks.create(active:true, email_pattern: "@schools.nyc.gov")
      user = crank!(:user, barcode: Integer(ENV['USER_BARCODE_ALLOTTED_RANGE_MINIMUM']))
      SierraCodeZcodeMatch.create(sierra_code: 1, zcode: user.school.code)

      mock_check_barcode_request(user.barcode.to_s, '404')
      increased_barcode = user.barcode + 1
      mock_check_barcode_request(increased_barcode.to_s, '404')

      get '/users/signup'
      assert_select 'h1', 'Sign Up'
      post '/users', params: {
        user: {
          first_name: user.first_name,
          last_name: user.last_name,
          email: new_email,
          pin: user.pin,
          school_id: user.school_id
        }
      }
      assert_response :redirect
      follow_redirect!
      assert 'div', 'Welcome! You have signed up successfully'
    end
  end
end
