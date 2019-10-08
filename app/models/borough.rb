class Borough < ActiveRecord::Base

  #attr_accessible :name

  has_many :schools

  default_scope { order('name ASC') }
end
