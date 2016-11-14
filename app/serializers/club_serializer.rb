class ClubSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :winery_name, :manager_fullname

  def winery_name
    object.winery.name
  end

  def manager_fullname
    object.winery.account.user.fullname
  end

end
