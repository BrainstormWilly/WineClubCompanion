FactoryGirl.define do
  factory :user do
    firstname Faker::Name.first_name
    lastname Faker::Name.last_name
    email Faker::Internet.email
    password "123456"
    password_confirmation "123456"
    role "member"
  end
end