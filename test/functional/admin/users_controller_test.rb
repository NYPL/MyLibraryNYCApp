# frozen_string_literal: true

require 'test_helper'
module Admin
  class UsersControllerTest < ActionController::TestCase
    setup do
      @user = users(:user1)
      sign_in AdminUser.create!(email: 'admin@example.com', password: 'password')
    end

    test "test index method" do
      get :index
      assert_response :success
    end

    test 'test form method' do
      post :new, params: { id: @user.id }
      assert_response :success
    end

    test "test show method" do
      get :show, params: { id: @user.id }
      assert_response :success
    end
  end
end
