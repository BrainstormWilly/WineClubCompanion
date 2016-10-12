FactoryGirl.define do
  factory :user do
    firstname Faker::Name.first_name
    lastname Faker::Name.last_name
    sequence(:email){|n| "user#{n}@wcc.com" }
    password "123456"
    password_confirmation "123456"
    role "member"
  end
end
