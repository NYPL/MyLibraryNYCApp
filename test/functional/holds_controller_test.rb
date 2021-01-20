# frozen_string_literal: true

require 'test_helper'

class HoldsControllerTest < ActionController::TestCase

  setup do
    @user = holds(:hold1).user
    @hold1 = holds(:hold1)
    @hold2 = holds(:hold2)
    @hold4 = holds(:hold4)
    @school_two = schools(:school_two)
  end

  test "should show holds" do
    get :show, params: { id: @hold1.access_key }
    assert_response :success
  end

  test "should get index" do
    get :index
    assert_response :redirect
  end


  test "should get new" do
    get :new, params: { teacher_set_id: @hold1.teacher_set_id }
    assert_response :success
  end

  test "should cancel hold" do
    post :cancel, params: { id: @hold1.access_key }
    assert_response :success
  end

  test "update teacher-set available_copies and cancel hold successfully" do
    sign_in @user
    expected_ts_available_copies = 4

    resp = post :update, params: { id: @hold1.access_key, hold_change: {"comment" => "qqq", "status" => "cancelled"}, hold: {status: "MyText"} }
    resp_hold_obj = resp.request.env["action_controller.instance"].current_user.holds.find(@hold1.id)
    # After cancellation of hold, status changed from "new" to "cancelled"
    assert_equal(resp_hold_obj.status, "cancelled")
    # Before cancellation of hold teacher-set available_copies count is 2.
    # After cancellation of hold teacher-set available_copies count is 4.
    assert_equal(expected_ts_available_copies, TeacherSet.find(resp_hold_obj.teacher_set_id).available_copies)
    assert_response :redirect
    assert_equal("Your order was successfully updated.", flash[:notice])
  end

  test "test update method with empty holds" do
    sign_in @user
    post :update, params: { id: @hold4.access_key, hold_change: {"comment" => "qqq", "status" => "cancelled"}, hold: {status: "MyText"} }
    assert_nil(flash[:notice])
  end

  test "Should fail hold cancelaltion" do
    sign_in @user
    expected_ts_available_copies = 2

    resp = post :update, params: { id: @hold1.access_key, hold_change: {"comment" => "qqq", "status" => "new"}, hold: {status: "new"} }
    resp_hold_obj = resp.request.env["action_controller.instance"].current_user.holds.find(@hold1.id)
    # Hold status not changed.
    assert_equal(resp_hold_obj.status, "new")
    # teacher-set available_copies also not changed, because hold is not cancelled.
    assert_equal(expected_ts_available_copies, TeacherSet.find(resp_hold_obj.teacher_set_id).available_copies)
    assert_response :redirect
  end

  test "create hold and update teacher-set available_copies" do
    expected_ts_available_copies = 0
    # Before hold creation teacher-set available copies is 2.
    sign_in @user
    resp = post :create, params: { id: @hold1.access_key, teacher_set_id: @hold1.teacher_set_id, query_params: {"quantity" => 2}, hold: {} }
    resp_hold_obj = resp.request.env["action_controller.instance"].current_user.holds.find(@hold1.id)
    # User requested 2 teacher-sets. After creation of hold teacher-set available_copies will zero.
    assert_equal(expected_ts_available_copies, TeacherSet.find(resp_hold_obj.teacher_set_id).available_copies)
  end

  test "should fail hold creation" do
    sign_out @user
    post :create, params: { id: @hold1.access_key, teacher_set_id: @hold1.teacher_set_id, query_params: {"quantity" => 1}, hold: {status: "MyText"} }
    assert_response :success
  end
end
