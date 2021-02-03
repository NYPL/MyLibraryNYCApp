# frozen_string_literal: true

require 'test_helper'

module Admin
  class AdminUsersControllerTest < ActionController::TestCase
    setup do
      @admin_user = admin_users(:one)
      sign_in AdminUser.create!(email: 'admin@example.com', password: 'password')
    end

    test "test index method" do
      response = get :index
      assert_equal("200", response.code)
      assert_response :success
    end
    
    test "test form method" do
      response = get :edit, id: @admin_user.id
      assert_equal("200", response.code)
      assert_response :success
    end

    test 'test enable_or_disable' do
      response = put :enable_or_disable, params: {id: @admin_user.id}
      assert_equal("E-mail notification change made!", flash[:notice])
      assert_equal("302", response.code)
      assert_response :redirect
    end
  end
end
