# frozen_string_literal: true

require 'test_helper'

class Api::BibsControllerTest < ActionController::TestCase
  def setup
    @controller = Api::V01::BibsController.new
  end

  test 'respond with 400 if request body is missing' do
    post 'create_or_update_teacher_sets'
    assert response.status == 400
  end

  test "should update teacher set even if an associate book has a field that is too long" do
    TeacherSet.destroy_all
    post 'create_or_update_teacher_sets', { _json: ONE_TEACHER_SET_WITH_A_BOOK_ISBN_OF_300_CHARACTERS }
    assert_response :success
    assert TeacherSet.count > 0
  end

  test "should update teacher set attributes and create associated books" do
    Book.destroy_all
    TeacherSet.destroy_all
    post 'create_or_update_teacher_sets', { _json: TWO_TEACHER_SETS_WITH_10_ISBNS_EACH }
    assert_response :success
    assert Book.count == 20
    assert TeacherSet.count == 2
    assert TeacherSet.first.books.count == 10
    assert TeacherSetBook.count == 20 # each teacher set has 10 books
    assert JSON.parse(response.body)['teacher_sets'].map{ |x| x['bnumber'] } == ["b#{BNUMBER1}", "b#{BNUMBER2}"]

    # simulate an update which removes seven books from each teacher_set
    post 'create_or_update_teacher_sets', { _json: TWO_TEACHER_SETS_WITH_3_ISBNS_EACH }
    assert_response :success
    assert Book.count == 20 # no change to books but TeacherSetBooks decrease
    assert TeacherSet.count == 2 # no change
    assert TeacherSet.first.books.count == 3
    assert TeacherSetBook.count == 6 # some records are deleted in the join table (compare to 20 records above)
    assert JSON.parse(response.body)['teacher_sets'].map{ |x| x['bnumber'] } == ["b#{BNUMBER1}", "b#{BNUMBER2}"]

    # confirm all teacher_set_fields are updated
    first_teacher_set = TeacherSet.first
    binding.pry
    assert first_teacher_set.title.present?
    assert first_teacher_set.call_number.present?
    assert first_teacher_set.description.present?
    assert first_teacher_set.edition.present?
    assert first_teacher_set.isbn.present?
    assert first_teacher_set.primary_language.present?
    assert first_teacher_set.publisher.present?
    assert first_teacher_set.contents.present?
    assert first_teacher_set.physical_description.present?
    assert first_teacher_set.details_url.present?
    assert_equal 0, first_teacher_set.grade_begin
    assert_equal 1, first_teacher_set.grade_end
    assert_equal 0, first_teacher_set.lexile_begin
    assert_equal nil, first_teacher_set.lexile_end
    assert first_teacher_set.availability.present?
    assert first_teacher_set.teacher_set_notes.any?
    assert first_teacher_set.subject_teacher_sets.count == 2
    # for some reason, this syntax won't work: `first_teacher_set.subjects.any?`
    assert first_teacher_set.subject_teacher_sets.map(&:subject).any?
  end

  test "should not create a teacher set if required field is missing (ie title)" do
    Book.destroy_all
    TeacherSet.destroy_all
    post 'create_or_update_teacher_sets', { _json: TEACHER_SET_WITH_TITLE_MISSING }
    assert_response :success
    assert Book.count == 0
    assert TeacherSet.count == 0
  end

  test "should delete teacher sets when given a bib number" do
    TeacherSet.where(bnumber: "b#{BNUMBER1}").first_or_create
    delete 'delete_teacher_sets', { _json: TWO_TEACHER_SETS_TO_DELETE }
    assert_response :success
    assert JSON.parse(response.body)['teacher_sets'].map{ |x| x['bnumber'] } == ["b#{BNUMBER1}"]
  end
end