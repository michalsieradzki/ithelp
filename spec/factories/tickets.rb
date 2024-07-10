FactoryBot.define do
  factory :ticket do
    title { "Example Ticket" }
    description { "This is an example ticket description" }
    status { "open" }
    priority { "medium" }
    association :user

    trait :with_assignment do
      association :assigned_to, factory: :support_user
    end

    factory :assigned_ticket, traits: [:with_assignment]
  end
end
