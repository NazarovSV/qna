FactoryBot.define do
  factory :vote do
    value { 1 }

    trait :like do
      value { 1 }
    end

    trait :dislike do
      value { -1 }
    end
  end
end
