# frozen_string_literal: true

require 'test_helper'
module Admin
  class HoldsControllerTest < ActionController::TestCase
    setup do
      @hold = holds(:hold1)
      sign_in AdminUser.create!(email: 'admin@example.com', password: 'password')
    end

    test "test index method" do
      get :index
      assert_response :success
    end

    test "test show method" do
      get :show, params: { id: @hold.id}
      assert_response :success
    end
  end
end
