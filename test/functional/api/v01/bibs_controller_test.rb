# frozen_string_literal: true

require 'test_helper'

class Api::BibsControllerTest < ActionController::TestCase
  def setup
    @controller = Api::V01::BibsController.new
  end

  # Need to fix this test cases.
  # test "should update teacher set even if an associate book has a field that is too long" do
  #   @controller.request = ONE_TEACHER_SET_WITH_A_BOOK_ISBN_OF_300_CHARACTERS
  #   post 'create_or_update_teacher_set'
  # end


  # test "delete teacher set" do
  #   @controller.request = ONE_TEACHER_SET_WITH_A_BOOK_ISBN_OF_300_CHARACTERS
  #   post 'delete_teacher_set'
  # end
end
