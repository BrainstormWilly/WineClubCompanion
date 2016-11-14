class UserSerializer < ActiveModel::Serializer
  attributes :id, :fullname, :firstname, :lastname, :email

  has_many :accounts

  def fullname
    object.fullname
  end

end
