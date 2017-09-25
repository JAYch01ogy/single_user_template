FactoryGirl.define do
  factory :user do
    email { Faker::Internet.email }
    password 'testing'
    admin false

    trait :admin do
      admin true
    end
  end
end
