require 'test_helper'

class Api::BibsControllerTest < ActionController::TestCase
  def setup
    @controller = Api::V1::BibsController.new
  end

  test "should create or update teacher sets when given a bib number" do
    post 'create_or_update_teacher_sets'
    assert_response :success
  end

  test "should delete teacher sets when given a bib number" do
    delete 'delete_teacher_sets'
    assert_response :success
  end
end
