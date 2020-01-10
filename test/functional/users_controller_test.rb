# frozen_string_literal: true

require 'test_helper'

class UsersControllerTest < ActionController::TestCase

  setup do
    @user = users(:user_one)
  end

  test "should get check_email" do
    mock_check_email_request(@user.email)
    get :check_email, params: {email: @user.email}
    assert_response :success
  end

  # test "should set settings" do
  #   get :show, params: { id: @teacher_set.id }
  #   assert_response :success
  # end

  test "should create user" do
    assert_no_difference 'User.count' do
      post :create, params: {user: {first_name: @user.first_name, last_name: @user.last_name, 
                                    email: @user.email, encrypted_password: @user.encrypted_password}}
    end
    assert_response :success
  end
end
