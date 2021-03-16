# frozen_string_literal: true

FactoryBot.define do
  sequence :body do |n|
    "MyText #{n}"
  end

  factory :answer do
    body
    question
    user

    trait :invalid do
      body { nil }
    end

    trait :with_attached_file do
      after(:create) do |question|
        question.files.attach(io: File.open(Rails.root.join("#{Rails.root}/spec/spec_helper.rb")), filename: 'spec_helper.rb')
      end
    end
  end
end
