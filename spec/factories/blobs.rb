FactoryBot.define do
    factory :blob do
        user
        id { Faker::Internet.uuid }
    end
end