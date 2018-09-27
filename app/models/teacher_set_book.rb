class TeacherSetBook < ActiveRecord::Base
  belongs_to :book
  belongs_to :teacher_set
  attr_accessible :book, :teacher_set, :rank

  def self.destroy_for_set(set_id)
    self.delete_all(:teacher_set_id => set_id)
  end
end
