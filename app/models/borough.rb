# frozen_string_literal: true

class Borough < ApplicationRecord

  # attr_accessible :name

  has_many :schools

  default_scope { order('name ASC') }
end
