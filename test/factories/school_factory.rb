# frozen_string_literal: true

class Cranky::Factory
  def school
    define name: "Queens Academy: College Prep",
           address_line_1: '100 Main St',
           address_line_2: 'Example, NY 10000',
           code: "z#{unique_school_code}",
           borough: 'QUEENS',
           active: true
  end

  def queens_school
    inherit(:school, code: "zq#{unique_school_code}", borough: 'QUEENS')
  end

  def bronx_school
    inherit(:school, code: "zx#{unique_school_code}", borough: 'BRONX')
  end

  def unique_school_code
    last_school = School.order(:id).last
    (last_school.present? ? last_school.id + 1 : 0).to_s
  end
end
