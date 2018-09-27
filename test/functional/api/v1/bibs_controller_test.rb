require 'test_helper'

class Api::BibsControllerTest < ActionController::TestCase
  def setup
    @controller = Api::V1::BibsController.new
  end

  test "should create or update a teacher set when given a bib number" do
    post 'create_or_update_teacher_set'
    assert_response :success
  end

  test "should delete a teacher set when given a bib number" do
    delete 'delete_teacher_set'
    assert_response :success
  end

  test "should create or update a book when given a bib number" do
    post 'create_or_update_book'
    assert_response :success
  end

  test "should delete a book when given a bib number" do
    delete 'delete_book'
    assert_response :success
  end
end
