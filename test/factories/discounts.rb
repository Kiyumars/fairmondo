FactoryGirl.define do
  factory :discount do
    title 'Rabatt'
    description 'a' * 25
    start_time 15.days.ago
    end_time 10.days.from_now
    percent { rand(1..100) }
    max_discounted_value_cents { rand(1000..10000) }
    num_of_discountable_articles { rand(1..20) }

    trait :small do
      max_discounted_value_cents 1
    end

    trait :big do
      percent 100
      max_discounted_value_cents 20000
    end
  end
end
