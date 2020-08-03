# frozen_string_literal: true

require 'test_helper'

class HoldsControllerTest < ActionController::TestCase

  setup do
    @user = holds(:hold1).user
    @hold1 = holds(:hold1)
    @hold2 = holds(:hold2)
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

  test "should update hold successfully" do
    post :update, params: { id: @hold1.access_key, hold_change: {"comment" => "qqq", "status" => "cancelled"}, hold: {status: "MyText"} }
    assert_response :redirect
    assert_equal("Your order was successfully updated.", flash[:notice])
  end

  test "should create hold" do
    sign_in @user
    post :create, params: { id: @hold1.access_key, teacher_set_id: @hold1.teacher_set_id, query_params: {"quantity" => 1}, hold: {status: "MyText"} }
  end

  test "should fail hold creation" do
    sign_out @user
    post :create, params: { id: @hold1.access_key, teacher_set_id: @hold1.teacher_set_id, query_params: {"quantity" => 1}, hold: {status: "MyText"} }
    assert_response :success
  end
end
