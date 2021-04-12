# frozen_string_literal: true

require 'test_helper'

# TODO: We had some functional tests that tested CRUD (create-update-delete)
# functionality of the teacher sets controller.  They were deleted in
# https://github.com/NYPL/MyLibraryNYCApp/pull/565/files, and need to be
# brought back, with changes that reflect the new ActiveRecord version.

class TeacherSetsTest < ActionController::TestCase

  setup do
    @teacher_set = TeacherSet.new
    @ts_one = teacher_sets(:teacher_set_one)
  end

  test 'test item microservice api endpoint' do
    @teacher_set.send(:send_request_to_items_microservice, BNUMBER1)
    assert_response :success
  end

  test 'test bib microservice api endpoint' do
    @teacher_set.send(:send_request_to_bibs_microservice, BNUMBER1)
    assert_response :success
  end

  test 'test update book method' do
    @teacher_set.update_included_book_list(SIERRA_USER['data'][0])
    assert_response :success
  end


  test "Update elastic search document in elastic-search" do
    teacher_set = teacher_sets(:teacher_set_six)
    resp = teacher_set.create_or_update_teacherset_document_in_es
    assert_equal(teacher_set.id.to_s, resp['_id'])
  end


  test 'Create teacher_set in db and elastic-search' do
    resp = TeacherSet.create_or_update_teacher_set(SIERRA_USER["data"][0])
    assert_equal(SIERRA_USER["data"][0]['title'], resp.title)
  end
end
