# frozen_string_literal: true

require 'test_helper'
class Admin::AdminUsersControllerTest < ActionController::TestCase

  setup do
    @admin_user = admin_users(:one)
    sign_in AdminUser.create!(email: 'admin@example.com', password: 'password')
  end

  test "test index method" do
    get :index
    assert_response :success
  end
  
  test "test form method" do
    get :edit, id: @admin_user.id
    assert_response :success
  end

  test 'test enable_or_disable' do
    put :enable_or_disable, params: {id: @admin_user.id}
    assert_response :redirect
  end

end
