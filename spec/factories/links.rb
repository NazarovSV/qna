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
  end
end
