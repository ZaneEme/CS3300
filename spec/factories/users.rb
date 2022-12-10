FactoryBot.define do
    factory :user do
      sequence(:email) { |n| "test#{n}@test.com" } 
      password { "qwerty" }
    end
end