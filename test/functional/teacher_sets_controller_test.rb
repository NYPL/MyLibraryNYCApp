# frozen_string_literal: true

require 'test_helper'

class TeacherSetsControllerTest < ActionController::TestCase
  setup do
    @teacher_set = teacher_sets(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:teacher_sets)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create teacher_set" do
    assert_difference('TeacherSet.count') do
      post :create, teacher_set: { description: @teacher_set.description, slug: @teacher_set.slug, title: @teacher_set.title }
    end

    assert_redirected_to teacher_set_path(assigns(:teacher_set))
  end

  test "should show teacher_set" do
    get :show, id: @teacher_set
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @teacher_set
    assert_response :success
  end

  test "should update teacher_set" do
    put :update, id: @teacher_set, teacher_set: { description: @teacher_set.description, slug: @teacher_set.slug, title: @teacher_set.title }
    assert_redirected_to teacher_set_path(assigns(:teacher_set))
  end

  test "should destroy teacher_set" do
    assert_difference('TeacherSet.count', -1) do
      delete :destroy, id: @teacher_set
    end

    assert_redirected_to teacher_sets_path
  end
end
