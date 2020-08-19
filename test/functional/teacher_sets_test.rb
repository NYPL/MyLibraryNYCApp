# frozen_string_literal: true

require 'test_helper'

# TODO: We had some functional tests that tested CRUD (create-update-delete)
# functionality of the teacher sets controller.  They were deleted in
# https://github.com/NYPL/MyLibraryNYCApp/pull/565/files, and need to be
# brought back, with changes that reflect the new ActiveRecord version.

class TeacherSetsTest < ActionController::TestCase
  test "test school strong params" do
    TeacherSet.new.update_set_type_from_nil_to_value
    assert_response :success
  end
end
