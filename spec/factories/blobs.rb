FactoryBot.define do
    factory :blob do
        user
        id { Faker::Internet.uuid }
        data { Faker::Lorem.characters(number: 50) }
    end
end