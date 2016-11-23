# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

def create_activities_for_winery(winery, deliveries)
  activities = []
  activities << Activity.create(name: "Wine Promotion", activity_type: "promotion", activity_sub_type: "wine", winery: winery)
  activities << Activity.create(name: "Shipping Promotion", activity_type: "promotion", activity_sub_type: "shipping", winery: winery)
  activities << Activity.create(name: "Shipping", activity_type: "shipping", winery: winery)
  activities << Activity.create(name: "Events", activity_type: "event", winery: winery)
  activities << Activity.create(name: "Newsletter", activity_type: "announcement", activity_sub_type: "newsletter", winery: winery)
  activities.each do |a|
    deliveries.each do |d|
      Delivery.create(channel: d, activity: a)
    end
  end
end

def create_subscriptions_for_member(winery, member)
  winery.activities.each do |a|
    # p "#{a.name}: #{winery.name}: #{member.fullname}: deliveries = #{a.deliveries.count} "
    a.deliveries.each do |d|
      Subscription.create(
        user: member,
        delivery: d,
        activated: d.channel=="email" ? true : false
      )

    end
  end
end


suffixes = [" Winery", " Vineyards", " Estate"]
5.times do
  winery = Winery.create(
    name: Faker::Company.name << suffixes.sample,
    address1: Faker::Address.street_address,
    city: Faker::Address.city,
    state: Faker::Address.state_abbr,
    zip: Faker::Address.zip_code
  )
  create_activities_for_winery(winery, ["email","phone","text","notification"])
end

wineries = Winery.all

csj = Winery.create(
  name: "Chateau St. Jean",
  address1: "8555 Sonoma Hwy",
  city: "Kenwood",
  state: "CA",
  zip: "95452"
)
create_activities_for_winery(csj, ["email","phone","text","notification"])

dcv = Winery.create(
  name: "Dry Creek Vineyard",
  address1: "3770 Lambert Bridge Rd.",
  city: "Healdsburg",
  state: "CA",
  zip: "95448"
)
create_activities_for_winery(dcv, ["email","phone","notification"])

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
    password_confirmation: "123456",
    role: "manager"
  )
  usr = User.create(
    firstname: Faker::Name.first_name,
    lastname: Faker::Name.last_name,
    email: Faker::Internet.email,
    password: "123456",
    password_confirmation: "123456"
  )
end

managers = User.where(role: "manager")
members = User.where(role: "member")

me_user = User.create(
  firstname: "Bill",
  lastname: "Langley",
  email: "bill@wineglassmarketing.com",
  password: "123456",
  password_confirmation: "123456"
)

me_mgr = User.create(
  firstname: "William",
  lastname: "Langley",
  email: "bill@ynoguy.com",
  password: "123456",
  password_confirmation: "123456",
  role: "manager"
)

me_admin = User.create(
  firstname: "Willy",
  lastname: "Langley",
  email: "brainstormwilly@gmail.com",
  password: "123456",
  password_confirmation: "123456",
  role: "admin"
)

10.times do
  member = members.sample
  club = clubs.sample
  mship = Membership.create(
    club: club,
    user: member
  )
  # p "===================================="
  # p "Member: #{member.fullname}"
  # p "Winery: #{club.winery.name}"
  # p "IsSubscribed: #{member.is_subscribed_to_winery?(club.winery)}"
  create_subscriptions_for_member(club.winery, member) unless member.is_subscribed_to_winery?(club.winery)
end

2.times do
  member = me_user
  club = clubs.sample
  mship = Membership.create(
    club: club,
    user: member
  )
  create_subscriptions_for_member(club.winery, member) unless member.is_subscribed_to_winery?(club.winery)
end

Account.create(
  winery: dcv,
  user: me_mgr
)

Account.create(
  winery: csj,
  user: me_mgr
)

wineries.each do |w|
  unless w == dcv || w == csj
    acct = Account.create(
      winery: w,
      user: managers.sample
    )
  end
end
