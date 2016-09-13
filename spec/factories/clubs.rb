FactoryGirl.define do
  wineries = Winery.all
  factory :club do
    name  "#{Faker::Lorem.word} Club"
    winery wineries.sample
    description Faker::Lorem.paragraph
  end
end
