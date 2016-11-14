class MembershipSerializer < ActiveModel::Serializer
  attributes :id, :registered, :user_fullname, :club_name, :winery_name

  # belongs_to :user
  # belongs_to :club

  def user_fullname
    object.user.fullname
  end

  def club_name
    object.club.name
  end

  def winery_name
  	object.club.winery.name
  end

end
