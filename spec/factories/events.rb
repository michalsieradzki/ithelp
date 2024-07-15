FactoryBot.define do
  factory :event do
    association :ticket
    association :user
    action_type { Event::COMMENT_ADDED }
    details { { comment_id: 1 } } # przykładowe szczegóły, dostosuj do potrzeb
  end
end
