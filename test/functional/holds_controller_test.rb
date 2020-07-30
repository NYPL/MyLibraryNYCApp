# frozen_string_literal: true

require 'test_helper'

class HoldsControllerTest < ActionController::TestCase

  setup do
    @hold = holds(:hold1)
  end

  test "should show holds" do
    get :show, params: { id: @hold.access_key }
    assert_response :success
  end

  test "should get new" do
    get :new, params: { teacher_set_id: @hold.teacher_set_id }
    assert_response :success
  end

  test "should cancel hold" do
    post :cancel, params: { id: @hold.access_key }
    assert_response :success
  end

  test "update" do
    @hold.instance_variable_set(:@hold, @hold)
    post :update, ActionController::Parameters.new("id" => @hold.access_key, "hold" => ActionController::Parameters.new({status: "MyText"}), 
                                                   "hold_change" => {"comment" => "qqq", "status" => "cancelled"}), format: :js
    assert_template :edit
  end
end
