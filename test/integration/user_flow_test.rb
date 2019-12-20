# frozen_string_literal: true

require 'test_helper'

class UserFlowTest < ActionDispatch::IntegrationTest
  test "user method assign_barcode increments last valid barcode by 1" do
    AllowedUserEmailMasks.create(active:true, email_pattern: "@schools.nyc.gov")
    user_one = crank!(:user, barcode: 27777000000099)
    user_two = crank(:user)
    user_two.assign_barcode
    assert(user_two.barcode == 27777000000100)
  end

  [generate_email].each do |new_email|
    test 'create new user record and send request to microservice' do
      AllowedUserEmailMasks.create(active:true, email_pattern: "@schools.nyc.gov")
      user = crank!(:user, barcode: 27777000000000)
      SierraCodeZcodeMatch.create(sierra_code: 1, zcode: user.school.code)
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
