# frozen_string_literal: true

class School < ActiveRecord::Base
  include CatalogItemMethods

  has_paper_trail

  before_save :disable_papertrail
  before_update :enable_papertrail
  after_save :enable_papertrail

  has_many :users

  default_scope { order('name ASC') }

  scope :active, -> { where(active: true) }

  validates :name, :presence => true

  def self.ransackable_attributes(auth_object = nil)
    ["active", "address_line_1", "address_line_2", "borough", "campus_id", "code", "created_at", "id", "id_value", "name", "phone_number", "postal_code", "state", "updated_at"]
  end

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
  
  # Get all active schools
  def self.active_schools_data
    active.map(&:name_id)
  end

  # Parse schoool name and id
  def name_id
    status_label = active ? "" : "[INACTIVE] "
    ["#{status_label}#{name + school_code}", id]
  end

  def school_code
    code.present? ? " (#{code[1..].upcase})" : ""
  end

end
