# frozen_string_literal: true

FactoryBot.define do

  factory :user do
    sequence :email do |n|
      "user#{n}@gmail.com"
    end

    password { '12345678' }
    password_confirmation { '12345678' }
    confirmed_at { DateTime.now }
  end
end
