# frozen_string_literal: true

require 'test_helper'

# TODO: We had some functional tests that tested CRUD (create-update-delete)
# functionality of the teacher sets controller.  They were deleted in
# https://github.com/NYPL/MyLibraryNYCApp/pull/565/files, and need to be
# brought back, with changes that reflect the new ActiveRecord version.

class SchoolsControllerTest < ActionController::TestCase
  setup do
    @school = schools(:school_one)
  end

  test "should get index" do
    get :index
    assert_response :success
  end

  test "test school strong params" do
    post :create, params: { name: "school_name" }
    assert_response :success
  end
end
