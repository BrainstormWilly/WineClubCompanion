class AccountSerializer < ActiveModel::Serializer
  attributes :id, :winery_id, :winery_name, :user_id, :user_fullname, :clubs

  def winery_name
    object.winery.name
  end

  def user_fullname
    object.user.fullname
  end

  def clubs
    object.winery.clubs.map{ |c| c.name }.join(", ")
  end

end
