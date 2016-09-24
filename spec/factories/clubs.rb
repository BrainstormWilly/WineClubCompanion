FactoryGirl.define do
  # wineries = Winery.all
  factory :club do
    name  "#{Faker::Lorem.word.capitalize} Club"
    winery nil
    description Faker::Lorem.paragraph
  end
end
