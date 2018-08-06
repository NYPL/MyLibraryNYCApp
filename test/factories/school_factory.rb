class Cranky::Factory
  # Simple factory method to create a user instance, you would call this via crank(:user)
  def school
    School.new do |u|
      u.id  = 1076
      u.name  =   "Antonia Pantoja Preparatory Academy: A College Boar..."        
      u.code  = 'zx376'              
      u.active =  true
    end
  end
end