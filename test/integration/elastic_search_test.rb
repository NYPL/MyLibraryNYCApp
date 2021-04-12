# frozen_string_literal: true

require 'test_helper'

class ElasticSearchTest < ActionDispatch::IntegrationTest

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
