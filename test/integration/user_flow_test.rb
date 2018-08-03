require 'test_helper'

class UserFlowTest < ActionDispatch::IntegrationTest
  # # Create sample test data
  # first_name = Faker::Name.first_name
  # last_name = Faker::Name.last_name
  # pin = [1, 1, 1, 1].map! { (0..9).to_a.sample }.join
  # school_id = School.create().id
  # password = 'password123'
  #
  # last_user = User.create!(
  #   first_name: first_name,
  #   last_name: last_name,
  #   email: generate_email,
  #   school_id: school_id,
  #   password: password,
  #   pin: pin,
  #   password_confirmation: password,
  #   barcode: 27777000000000
  # )
  #
  # new_user = User.create!(
  #   first_name: first_name,
  #   last_name: last_name,
  #   email: generate_email,
  #   school_id: school_id,
  #   password: password,
  #   pin: pin,
  #   password_confirmation: password
  # )

  # Test that generated barcode is a 14-digit string, starting with '27777'.
  test "user method assign_barcode increments last valid barcode by 1" do
    new_user.assign_barcode
    assert(new_user.reload.barcode == 27777000000001)
  end

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
end
