class Cranky::Factory
  # Simple factory method to create a user instance, you would call this via crank(:user)
  def user
    User.new do |u|
      u.first_name  = options[:first_name] || Faker::Name.first_name 
      u.last_name  =  options[:first_name] || Faker::Name.last_name         
      u.email  = 'navrajnat@schools.nyc.gov'              
      u.pin =  options[:pin] || [1, 1, 1, 1].map! { (0..9).to_a.sample }.join
      u.school_id = 9999
      u.password = 'password123'
      u.password_confirmation = 'password123'
    end
  end
end