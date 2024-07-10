FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    password { "password" }
    password_confirmation { "password" }

    trait :admin do
      role { :admin }
    end

    trait :support do
      role { :support }
    end

    factory :admin_user, traits: [:admin]
    factory :support_user, traits: [:support]
  end
end
