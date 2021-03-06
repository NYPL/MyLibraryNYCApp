# frozen_string_literal: true

class Faq < ActiveRecord::Base
  acts_as_list :add_new_at => :bottom
  validates :position, uniqueness: true, allow_blank: false, allow_nil: false
  validates :question, :answer, :presence => true

  # Reordering of Frequently asked question when faq is destroyed.
  before_destroy { |record| record.remove_from_list }
  scope :get_faqs, -> { order("position ASC") }
end
