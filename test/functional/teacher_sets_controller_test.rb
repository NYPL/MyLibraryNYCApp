# frozen_string_literal: true

require 'test_helper'
require 'mocha/minitest'

# TODO: We had some functional tests that tested CRUD (create-update-delete)
# functionality of the teacher sets controller.  They were deleted in
# https://github.com/NYPL/MyLibraryNYCApp/pull/565/files, and need to be
# brought back, with changes that reflect the new ActiveRecord version.

class TeacherSetsControllerTest < ActionController::TestCase

  setup do
    @teacher_set = teacher_sets(:teacher_set_one)
  end

  test "should get index" do
    @elastic_search_mock = mock('ElasticSearch')
    @elastic_search_mock.stubs(:search).returns([])
    @elastic_search_mock.stubs(:get_teacher_sets_from_es).returns([{}, [], 0])
    ElasticSearch.stubs(:new).returns(@elastic_search_mock)

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
