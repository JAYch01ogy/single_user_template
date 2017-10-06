FactoryGirl.define do
  factory :user do
    email { Faker::Internet.email }
    password 'testing'
    name { "#{Faker::Name.first_name} #{Faker::Name.last_name}" }

    trait :admin do
      admin true
    end
  end
end
