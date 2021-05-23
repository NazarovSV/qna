# frozen_string_literal: true

FactoryBot.define do
  sequence :title do |n|
    "MyString #{n}"
  end

  factory :question do
    title
    body { 'MyText' }
    user
    best_answer_id { nil }

    trait :invalid do
      title { nil }
    end

    trait :with_attached_file do
      after(:create) do |question|
        question.files.attach(io: File.open(Rails.root.join("#{Rails.root}/spec/spec_helper.rb")), filename: 'spec_helper.rb')
      end
    end

    trait :with_attached_files do
      after(:create) do |question|
        question.files.attach(io: File.open(Rails.root.join("#{Rails.root}/spec/spec_helper.rb")), filename: 'spec_helper.rb')
        question.files.attach(io: File.open(Rails.root.join("#{Rails.root}/spec/rails_helper.rb")), filename: 'rails_helper.rb')
      end
    end

    trait :with_link do
      links { [attributes_for(:link)] }
    end

  end
end
