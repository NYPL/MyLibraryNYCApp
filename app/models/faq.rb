class Faq < ApplicationRecord
  acts_as_list :add_new_at => :top
  validates :position, uniqueness: true, allow_blank: false, allow_nil: false

  before_destroy{ |record| record.remove_from_list }
  scope :get_faqs, -> { order("position ASC") }
end
