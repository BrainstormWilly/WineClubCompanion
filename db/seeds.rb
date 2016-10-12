# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


suffixes = [" Winery", " Vineyards", " Estate"]
5.times do
  winery = Winery.create(
    name: Faker::Company.name << suffixes.sample,
    address1: Faker::Address.street_address,
    city: Faker::Address.city,
    state: Faker::Address.state_abbr,
    zip: Faker::Address.zip_code
  )
end

csj = Winery.create(
  name: "Chateau St. Jean",
  address1: "8555 Sonoma Hwy",
  city: "Kenwood",
  state: "CA",
  zip: "95452"
)

dcv = Winery.create(
  name: "Dry Creek Vineyard",
  address1: "3770 Lambert Bridge Rd.",
  city: "Healdsburg",
  state: "CA",
  zip: "95448"
)

wineries = Winery.all

20.times do
  club = Club.create(
    name: "#{Faker::Lorem.word.capitalize} Club",
    winery: wineries.sample,
    description: Faker::Lorem.paragraph
  )
end

clubs = Club.all

5.times do
  mgr = User.create(
    firstname: Faker::Name.first_name,
    lastname: Faker::Name.last_name,
    email: Faker::Internet.email,
    password: "123456",
    role: "manager"
  )
  usr = User.create(
  firstname: Faker::Name.first_name,
  lastname: Faker::Name.last_name,
  email: Faker::Internet.email,
  password: "123456"
  )
end

managers = User.where(role: "manager")
members = User.where(role: "member")

me_user = User.new(
  firstname: "Bill",
  lastname: "Langley",
  email: "bill@wineglassmarketing.com",
  password: "123456"
)
me_user.save

me_mgr = User.new(
  firstname: "William",
  lastname: "Langley",
  email: "bill@ynoguy.com",
  password: "123456",
  role: "manager"
)
me_mgr.save

me_admin = User.new(
  firstname: "Willy",
  lastname: "Langley",
  email: "brainstormwilly@gmail.com",
  password: "123456",
  role: "admin"
)
me_admin.save

2.times do
  mship = Membership.create(
    club: clubs.sample,
    user: me_user
  )
end

2.times do
  acct = Account.create(
    winery: wineries.sample,
    user: me_mgr
  )
end

10.times do
  mship = Membership.create(
    club: clubs.sample,
    user: members.sample
  )
end

5.times do
  acct = Account.create(
    winery: wineries.sample,
    user: managers.sample
  )
end
