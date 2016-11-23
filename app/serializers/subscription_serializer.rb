class SubscriptionSerializer < ActiveModel::Serializer
  attributes :id, :activated, :delivery_id, :member_fullname, :delivery_channel, :activity_id, :activity_name

  def member_fullname
    object.user.fullname
  end

  def delivery_channel
    object.delivery.channel
  end

  def activity_id
    object.delivery.activity.id
  end

  def activity_name
    object.delivery.activity.name
  end

end
