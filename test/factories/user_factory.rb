class Cranky::Factory
  def user
    define first_name: options[:first_name] || Faker::Name.first_name,
           last_name: options[:last_name] || Faker::Name.last_name,
           email: ('a'..'z').to_a.shuffle[0, 8].join + Time.now.to_i.to_s + '@schools.nyc.gov',
           alt_email: options[:alt_email] || Faker::Internet.email,
           password: 'password123',
           password_confirmation: 'password123',
           pin: 1234,
           school: queens_school
  end

  def queens_user
    inherit(:user)
  end

  def bronx_user
    inherit(:user, school: bronx_school)
  end
end
