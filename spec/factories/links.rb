FactoryBot.define do
  sequence :name do |n|
    "My link #{n}"
  end

  sequence :url do |n|
    "https://www.google#{n}.ru/"
  end

  factory :link do
    name
    url

    trait :gist do
      url { 'https://gist.github.com/NazarovSV/3f4c2beeeb901a8db1dab9419b2b37aa' }
    end
  end
end
