# frozen_string_literal: true

require 'test_helper'

class HoldsControllerTest < ActionController::TestCase
  extend Minitest::Spec::DSL

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


  test "should fail hold creation" do
    sign_out @user
    post :create, params: { id: @hold1.access_key, teacher_set_id: @hold1.teacher_set_id, query_params: {"quantity" => 1}, hold: {status: "MyText"} }
    assert_response :success
  end
end
