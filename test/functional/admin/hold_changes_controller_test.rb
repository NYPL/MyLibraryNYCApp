# frozen_string_literal: true

require 'test_helper'
module Admin
  class HoldChangesControllerTest < ActionController::TestCase

    setup do
      @hold_change = hold_changes(:hold_changes1)
      @hold_change2 = hold_changes(:hold_changes2)
      @user = users(:user1)
      sign_in AdminUser.create!(email: 'admin@example.com', password: 'password')
    end

    test "test index method" do
      get :index
      assert_equal("200", response.code)
      assert_response :success
    end


    test "test show method" do
      get :show, params: { id: @hold_change.id}
      assert_equal("200", response.code)
      assert_response :success
    end

    test "test create method" do
      sign_in @user
      resp = post :create, params: { id: @hold_change2.id, hold_change: {status: "closed", hold_id: @hold_change2.hold_id}}
      resp_hold_obj = resp.request.env["action_controller.instance"].current_user.holds.find(@hold_change2.hold_id)
      assert_equal(2, resp_hold_obj.quantity)
      assert_equal("302", response.code)
      assert_response :redirect
    end

    test 'test form method' do
      post :new, params: {hold: @hold_change.hold_id}
      assert_equal("200", response.code)
      assert_response :success
    end
  end
end
