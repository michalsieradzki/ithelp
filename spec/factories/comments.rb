FactoryBot.define do
  factory :comment do
    body { "Comment content" }
    association :user
    association :ticket
  end
end
