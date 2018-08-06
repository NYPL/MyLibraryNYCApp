require 'test_helper'

class UserFlowTest < ActionDispatch::IntegrationTest

  email = generate_email

  school = crank(:school)
  user = crank(:user)

  test 'create new user record and send request to microservice' do
    get '/users/signup'
    assert_select 'h1', 'Sign Up'
    post '/users',
    user: {
      first_name: user.first_name,
      last_name: user.last_name,
      email: email,
      pin: user.pin,
      school_id: user.school_id
    }
    puts response.body
    assert_response :redirect
    follow_redirect!
    assert 'div', 'Welcome! You have signed up successfully'
  end
end
