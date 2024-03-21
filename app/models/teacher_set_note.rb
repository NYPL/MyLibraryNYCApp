# frozen_string_literal: true

class TeacherSetNote < ActiveRecord::Base
  # belongs_to :book_set
  # attr_accessible :content, :teacher_set_id

  def as_json(opts={})
    ret = {}
    [:content].each do |p|
      ret[p] = self[p]
    end
    ret
  end
end
