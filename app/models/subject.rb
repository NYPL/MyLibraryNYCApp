class Subject < ActiveRecord::Base
  #attr_accessible :title

  has_many :subject_teacher_sets, dependent: :delete_all
  has_many :teacher_sets, through: :subject_teacher_sets

  MIN_COUNT_FOR_FACET = 5

end
