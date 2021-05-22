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
      after(:create) do |answer|
        answer.files.attach(io: File.open(Rails.root.join("#{Rails.root}/spec/spec_helper.rb")), filename: 'spec_helper.rb')
      end
    end

    trait :with_attached_files do
      after(:create) do |answer|
        answer.files.attach(io: File.open(Rails.root.join("#{Rails.root}/spec/spec_helper.rb")), filename: 'spec_helper.rb')
        answer.files.attach(io: File.open(Rails.root.join("#{Rails.root}/spec/rails_helper.rb")), filename: 'rails_helper.rb')
      end
    end

    trait :best_answer do
      after(:create) do |answer|
        answer.question.best_answer = answer
      end
    end
  end
end
