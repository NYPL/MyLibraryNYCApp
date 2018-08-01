class School < ActiveRecord::Base

  attr_accessible :name

  belongs_to :campus
  has_many :users

  default_scope order('name ASC')

  scope :active, -> { where(active: true) }

  def full_name(delim = ', ')
    n = name
    if !campus.nil?
      if campus.schools.size > 1
        n += "#{delim}#{campus.name}"
      end

      if !campus.borough.nil?
        n += "#{delim}#{campus.borough.name}"
      end
    end
    n
  end
end
