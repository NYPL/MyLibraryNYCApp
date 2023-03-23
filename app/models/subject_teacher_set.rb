# frozen_string_literal: true

class SubjectTeacherSet < ApplicationRecord
  # attr_accessible :subject_id, :teacher_set_id

  belongs_to :subject
  belongs_to :teacher_set
end
