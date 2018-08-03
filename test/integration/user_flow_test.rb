require 'test_helper'

class UserFlowTest < ActionDispatch::IntegrationTest
  first_name = Faker::Name.first_name
  last_name = Faker::Name.last_name
  email = generate_email
  pin = [1, 1, 1, 1].map! { (0..9).to_a.sample }.join
  school_id = '1076'

  test 'create new user record and send request to microservice' do
    get '/users/signup'
    assert_select 'h1', 'Sign Up'
    post '/users',
    user: {
      first_name: first_name,
      last_name: last_name,
      email: email,
      pin: pin,
      school_id: school_id
    }
    assert_response :redirect
    follow_redirect!
    assert 'div', 'Welcome! You have signed up successfully'
  end


  # Test that generated barcode is a 14-digit string, starting with '27777'.
  test "user method generate_barcode returns valid string" do
    assert(/2777\d{10}/ === user.generate_barcode)
  end

end
