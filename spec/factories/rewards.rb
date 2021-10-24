FactoryBot.define do
  factory :reward do
    name { 'Reward name' }
    question
    user

    after(:build) do |reward|
      reward.image.attach(
        io:           File.open("#{Rails.root}/spec/files/reward.jpg"),
        filename:     'reward.jpg',
        content_type: 'image/jpg'
      )
    end
  end
end
