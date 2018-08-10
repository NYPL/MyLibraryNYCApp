class Cranky::Factory
  def school
    define name: "Queens Academy: College Prep",
           address_line_1: '100 Main St',
           address_line_2: 'Example, NY 10000',
           code: 'z' + rand.to_s[2..4],
           borough: 'Manhattan',
           active: true
  end

  def queens_school
    inherit(:school, code: 'zq' + rand.to_s[2..4], borough: 'QUEENS')
  end

  def bronx_school
    inherit(:school, code: 'zx' + rand.to_s[2..4], borough: 'BRONX')
  end
end

