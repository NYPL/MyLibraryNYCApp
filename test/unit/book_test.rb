# frozen_string_literal: true

require 'test_helper'

class BookTest < ActiveSupport::TestCase
  test 'creating a book does not create a version, because papertrail is turned off in the model' do
    # we turn it off this way in category_item_methods.rb for creating new sets via the admin dashboard
    crank!(:book)
    assert PaperTrail::Version.count == 0
  end

  test 'updating a book creates a version for the book and a version for the teacher set' do
    PaperTrail.enabled = false
    book = crank!(:book)
    teacher_set = crank!(:teacher_set)
    PaperTrail.enabled = true
    assert PaperTrail::Version.count == 0
    TeacherSetBook.create(teacher_set: teacher_set, book: book)
    assert PaperTrail::Version.count == 1
    book.update_attributes(title: 'Title2')
    # one update of a book creates a new version for that book and for its teacher set so the count increments by 2
    assert PaperTrail::Version.count == 3
  end
end
