# frozen_string_literal: true

require 'test_helper'
module Admin
  class HoldsControllerTest < ActionController::TestCase
    setup do
      @hold = holds(:hold2)
      sign_in AdminUser.create!(email: 'admin@example.com', password: 'password')
    end

    test "test index method" do
      get :index
      assert_equal("200", response.code)
      assert_response :success
    end

    test "test show method" do
      get :show, params: { id: @hold.id}
      assert_equal("200", response.code)
      assert_response :success
    end

    test "test close method with format js" do
      put :close, params: { id: @hold.id }
      assert_equal("302", response.code)
      assert_response :redirect
    end
  end
end
