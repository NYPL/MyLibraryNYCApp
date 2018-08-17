class School < ActiveRecord::Base
  has_many :users

  default_scope order('name ASC')

  scope :active, -> { where(active: true) }

  def full_name(delim = ', ')
    n = name
    n += "#{delim}#{borough}" if !borough.nil?
    n
  end
end
