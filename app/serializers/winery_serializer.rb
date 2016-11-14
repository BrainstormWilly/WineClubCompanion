class WinerySerializer < ActiveModel::Serializer
  attributes :id, :address1, :address2, :city, :state, :zip, :name, :manager_fullname, :club_list

  has_many :clubs

  def manager_fullname
    object.account.user.fullname
  end

  def club_list
    object.account.winery.clubs.map{ |c| c.name }.join(", ")
  end

end
