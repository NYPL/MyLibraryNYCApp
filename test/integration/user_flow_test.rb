require 'test_helper'

class UserFlowTest < ActionDispatch::IntegrationTest
 
setup do 
   @school = crank!(:school)
   @user = crank!(:user, :school_id => @school.id)
end

  # Test that generated barcode is a 14-digit string, starting with '27777'.
  test "user method assign_barcode increments last valid barcode by 1" do
    user_two = crank!(:user, :school_id => @school.id)
    @user.assign_barcode
    assert(@user.barcode == 27777099999999)
  end

[generate_email].each do |new_email|
  test 'create new user record and send request to microservice' do
    get '/users/signup'
    assert_select 'h1', 'Sign Up'
    post '/users',
    user: {
      first_name: @user.first_name,
      last_name: @user.last_name,
      email: new_email,
      pin: @user.pin,
      school_id: @school.id
    }
    puts response.body
    assert_response :redirect
    follow_redirect!
    assert 'div', 'Welcome! You have signed up successfully'
  end
end 


  # Test that generated barcode is a 14-digit string, starting with '27777'.
  # test "user method generate_barcode returns valid string" do
  #   assert(/\A2777\d{10}\z/ === user.generate_barcode)
  # end

end
