# frozen_string_literal: true

class Subject < ActiveRecord::Base
  # attr_accessible :title

  has_many :subject_teacher_sets, dependent: :delete_all
  has_many :teacher_sets, through: :subject_teacher_sets

  MIN_COUNT_FOR_FACET = 5

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "id", "id_value", "title", "updated_at"]
  end

end
