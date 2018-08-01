class Campus < ActiveRecord::Base
  self.table_name = "campuses"

  attr_accessible :name

  has_many :schools
  belongs_to :borough
  
  default_scope order('name ASC')
end
