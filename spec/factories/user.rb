FactoryGirl.define do
  factory :user do
    email { Faker::Internet.email }
    password 'testing'
    admin false
    name { "#{Faker::Name.first_name} #{Faker::Name.last_name}" }

    trait :admin do
      admin true
    end
  end
end
