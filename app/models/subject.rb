class Subject < ActiveRecord::Base
  attr_accessible :title

  has_and_belongs_to_many :teacher_sets

  MIN_COUNT_FOR_FACET = 5

end
