class ActivitySerializer < ActiveModel::Serializer
  attributes :id, :name, :activity_type, :activity_sub_type, :winery_name

  has_many :deliveries

  def winery_name
    object.winery.name
  end

end
