FactoryBot.define do

  factory :reward do
    name { 'Reward' }
    image { Rack::Test::UploadedFile.new('spec/support/files/img.png', 'image/png') }
  end
end
