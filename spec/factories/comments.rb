FactoryBot.define do
  factory :comment do
    sequence :body do |n|
      "Comment ##{n}"
    end
  end
end
