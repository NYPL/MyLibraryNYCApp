# frozen_string_literal: true

class School < ActiveRecord::Base
  has_many :users

  default_scope { order('name ASC') }

  scope :active, -> { where(active: true) }

  # Full name of school + comma & borough if borough is present.
  # Comma can be overridden with any other punctuation mark that is passed in as the one argument.
  def full_name(delim = ', ')
    n = name
    n += "#{delim}#{borough}" if !borough.nil?
    n
  end

  # This looks up a SierraCodeZcodeMatch by the school's zcode (ie "zk003")
  # and returns the sierra_code Sierra uses to lookup a zcode (ie "1")
  def sierra_code
    match = SierraCodeZcodeMatch.find_by_zcode(code)
    return nil if !match
    return match.sierra_code
  end
end
