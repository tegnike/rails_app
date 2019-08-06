FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "User#{n}" }
    sequence(:email) { |n| "tester#{n}@example.com" }
    password { "password" }
    password_confirmation { "password" }
    activated { true }
    activated_at { Time.zone.now }
  end

  factory :michael, class: User do
    name { "Michael Example" }
    email { "michael@example.com" }
    password { "password" }
    password_confirmation { "password" }
    admin { true }
    activated { true }
    activated_at { Time.zone.now }
  end

  factory :archer, class: User do
    name { "Sterling Archer" }
    email { "duchess@example.gov" }
    password { "password" }
    password_confirmation { "password" }
    activated { true }
    activated_at { Time.zone.now }
  end
end
