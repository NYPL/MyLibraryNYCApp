# frozen_string_literal: true

class AddLastBookChangeToTeacherSets < ActiveRecord::Migration[4.2]
  # This helps us get a snapshot of what the book's title was at that time by saving that data
  # on the teacher set.  We have to change something about the teacher set for Paper Trail to
  # create a new version.  Examples of what we save in that field: `deleted-ID_OF_BOOK-Title goes here`
  # and `updated-ID_OF_BOOK-Title goes here`.  This is especially helpful if a book is deleted.
  def change
    add_column :teacher_sets, :last_book_change, :string
  end
end
