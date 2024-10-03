FactoryBot.define do
  factory :book do
  end

  factory :faq do
  end

  factory :hold do
    teacher_set { create(:teacher_set) }
    user { create(:user) }
  end

  factory :teacher_set do
    available_copies { 5 }
  end

  factory :user do
    email { 'test_user@schools.nyc.gov' }
    password { Faker::Internet.password }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    barcode { Faker::Number.number }
    school { create(:school) }

    after(:build) do |user|
      create(:allowed_user_email_masks)
    end
  end

  factory :allowed_user_email_masks do
    active { true }
    email_pattern { '@schools.nyc.gov' }
  end

  factory :school do
    name { 'Test School' }
  end
end
