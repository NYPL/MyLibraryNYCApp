# frozen_string_literal: true

require 'test_helper'

# TODO: We had some functional tests that tested CRUD (create-update-delete)
# functionality of the teacher sets controller.  They were deleted in
# https://github.com/NYPL/MyLibraryNYCApp/pull/565/files, and need to be
# brought back, with changes that reflect the new ActiveRecord version.

class TeacherSetsControllerTest < ActionController::TestCase

  setup do
    @teacher_set = teacher_sets(:teacher_set_one)
  end

  test "should get index" do
    get :index
    assert_response :success
  end

  test "should show teacher_set" do
    get :show, params: { id: @teacher_set.id }
    assert_response :success
  end

  test "test teacher-set strong params" do
    post :create, params: { id: 1 }
    assert_response :success
  end
end
