class Cranky::Factory
  # Simple factory method to create a user instance, you would call this via crank(:user)
  def user
    User.new do |u|
      u.id = rand(10...100000) 
      u.first_name  = options[:first_name] || Faker::Name.first_name 
      u.last_name  =  options[:last_name] || Faker::Name.last_name         
      u.email  = ('a'..'z').to_a.shuffle[0, 8].join + Time.now.to_i.to_s + '@schools.nyc.gov'             
      u.pin =  options[:pin] || [1, 1, 1, 1].map! { (0..9).to_a.sample }.join
      u.barcode = 27777099999998
      u.school_id = options[:school_id] || 9999
      u.password = 'password123'
      u.password_confirmation = 'password123'
    end
  end
end