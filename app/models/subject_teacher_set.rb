class SubjectTeacherSet < ActiveRecord::Base
  attr_accessible :subject_id, :teacher_set_id

  belongs_to :subject
  belongs_to :teacher_set
end
