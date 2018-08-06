class Cranky::Factory
  # Simple factory method to create a user instance, you would call this via crank(:user)
  def school
    School.new do |u|
      u.id  = [1,1,1,1].map!{|x| (0..9).to_a.sample}.join.to_i
      u.name  =   "Antonia Pantoja Preparatory Academy: A College Boar..."        
      u.code  = 'zx' + rand.to_s[2..4]             
      u.active =  true
    end
  end
end