# frozen_string_literal: true

require 'test_helper'

class HoldsControllerTest < ActionController::TestCase
  extend Minitest::Spec::DSL
  require 'minitest/stub_any_instance'

  setup do
    @user = holds(:hold1).user
    @hold1 = holds(:hold1)
    @hold2 = holds(:hold2)
    @hold4 = holds(:hold4)
    @teacher_set = teacher_sets(:teacher_set_one)
    @teacher_set2 = teacher_sets(:teacher_set_two)
    @school_two = schools(:school_two)
  end

  test "should show holds" do
    get :show, params: { id: @hold2.access_key }
    assert_response :success
  end

  test "should get index" do
    get :index
    assert_response :redirect
  end


  test "should get new" do
    get :new, params: { teacher_set_id: @hold2.teacher_set_id }
    assert_response :success
  end

  test "should cancel hold" do
    post :holds_cancel_details, params: { id: @hold2.access_key }
    assert_response :success
  end

  test "update teacher-set available_copies and cancel hold successfully" do
    sign_in @user
    resp = nil
    es_doc = {"_index" => "teacherset", "_type" => "teacherset", 
              "_id" => @hold2.teacher_set.id, "_version" => 11, "result" => "updated", 
              "_shards" => {"total" => 0, "successful" => 1, "failed" => 0}}

    # Teacher_set available_copies before cancellation of hold.
    assert_equal(2, @hold2.teacher_set.available_copies)

    TeacherSet.stub_any_instance :update_teacher_set_availability_in_elastic_search, es_doc do
      resp = post :update, params: { id: @hold2.access_key, hold_change: {"comment" => "qqq", "status" => "cancelled"}, hold: {status: "MyText"} }
    end
    resp_hold_obj = resp.request.env["action_controller.instance"].current_user.holds.find(@hold2.id)
    # After cancellation of hold, status changed from "new" to "cancelled"
    assert_equal(resp_hold_obj.status, "cancelled")
    # Before cancellation of hold teacher-set available_copies count is 2.
    # After cancellation of hold teacher-set available_copies count is 3.
    assert_equal(3, TeacherSet.find(resp_hold_obj.teacher_set_id).available_copies)
    assert_response :success
    assert_equal("Your order was successfully updated.", JSON.parse(response.body)['message'])
  end

  test "test update method with empty holds" do
    sign_in @user
    es_doc = {
      "_index" => "teacherset",
      "_type" => "teacherset",
      "_id" => @hold4.teacher_set.id,
      "_version" => 11,
      "result" => "updated",
      "_shards" => {
        "total" => 0,
        "successful" => 1,
        "failed" => 0
      }
    }

    TeacherSet.stub_any_instance :update_teacher_set_availability_in_elastic_search, es_doc do
      post_params = {
        id: @hold4.access_key,
        hold_change: {
          "comment" => "qqq", "status" => "MyText"
        },
        hold: { status: "MyText" }
      }

      post :update, params: post_params
    end

    assert_nil(flash[:notice])
  end

  test "test hold cancellation method with hold status new" do
    # If hold status is new, hold cancellation method is not allowed to cancel the hold.
    sign_in @user

    # Teacher_set available_copies before cancellation of hold.
    assert_equal(2, @hold2.teacher_set.available_copies)

    post_params = {
      id: @hold2.access_key,
      hold_change: {
        "comment" => "qqq",
        "status" => "new"
      },
      hold: { status: "new" }
    }
    resp = post :update, params: post_params
    resp_hold_obj = resp.request.env["action_controller.instance"].current_user.holds.find(@hold2.id)
    # Hold status not changed.
    # teacher-set available_copies also not changed, because hold is not cancelled.
    assert_equal(resp_hold_obj.status, "new")
    assert_equal(2, TeacherSet.find(resp_hold_obj.teacher_set_id).available_copies)
    assert_response :success
  end

  test "create hold and update teacher-set available_copies" do
    sign_in @user
    resp = nil
    es_doc = {"_index" => "teacherset", "_type" => "teacherset", 
              "_id" => @hold2.teacher_set.id, "_version" => 11, "result" => "created", 
              "_shards" => {"total" => 0, "successful" => 1, "failed" => 0}}
    # Before hold creation teacher-set available copies is 2.
    assert_equal(2, @hold2.teacher_set.available_copies)
    TeacherSet.stub_any_instance :update_teacher_set_availability_in_elastic_search, es_doc do
      resp = post :create, params: { id: @hold2.access_key, teacher_set_id: @hold2.teacher_set_id, query_params: {"quantity" => 1}, hold: {} }
    end
    resp_hold_obj = resp.request.env["action_controller.instance"].current_user.holds.find(@hold2.id)
    # User requested 1 teacher-sets. After creation of hold teacher-set available_copies will 1.
    assert_equal(1, TeacherSet.find(resp_hold_obj.teacher_set_id).available_copies)
  end

  test "should fail hold creation" do
    sign_out @user
    post :create, params: { id: @hold1.access_key, teacher_set_id: @hold1.teacher_set_id, query_params: {"quantity" => 1}, hold: {status: "MyText"} }
    assert_response :success
  end
end
