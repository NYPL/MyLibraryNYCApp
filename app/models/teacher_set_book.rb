# frozen_string_literal: true

class TeacherSetBook < ActiveRecord::Base
  belongs_to :book
  belongs_to :teacher_set
  # attr_accessible :book, :teacher_set, :rank
  after_create :create_teacher_set_version_on_create
  # without prepending, associated teacher sets were already deleted, so they couldn't be versioned
  before_destroy :create_teacher_set_version_on_destroy, prepend: true

  def create_teacher_set_version_on_create
    teacher_set.update(last_book_change: "added-#{self.book.id}-#{self.book.title}")
  end

  def create_teacher_set_version_on_destroy
    teacher_set.update(last_book_change: "removed-#{self.book.id}-#{self.book.title}")
  end

  def self.destroy_for_set(set_id)
    self.delete_all(:teacher_set_id => set_id)
  end
end
