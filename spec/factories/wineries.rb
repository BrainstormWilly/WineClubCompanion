FactoryGirl.define do
  suffixes = [" Winery", " Vineyards", " Estate"]
  factory :winery do
    name Faker::Company.name << suffixes.sample
    address1 Faker::Address.street_address
    city Faker::Address.city
    state Faker::Address.state_abbr
    zip Faker::Address.zip_code
  end
end
