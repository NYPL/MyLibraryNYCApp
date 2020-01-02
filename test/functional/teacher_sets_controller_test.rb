# frozen_string_literal: true

require 'test_helper'

class TeacherSetsControllerTest < ActionController::TestCase

  setup do
    @teacher_set = teacher_sets(:teacher_set_one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:teacher_sets)
  end

  test "should show teacher_set" do
    get :show, params: { id: @teacher_set.id }
    assert_response :success
  end

  test "should create teacher_set" do
    assert_no_difference 'TeacherSet.count' do
      post :create, params: {teacher_set: {description: @teacher_set.description, title: @teacher_set.title}}
    end
    assert_response :success
  end
end
