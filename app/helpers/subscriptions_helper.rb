module SubscriptionsHelper

  def user_clubs_by_winery(w)
    current_user.memberships.select{ |m| m.club.winery == w }.map{ |m| m.club.name }.join(", ")
  end

  def user_is_subscribed_to_activity?(activity)
    @subscriptions.each do |s|
      if s.delivery.activity == activity && s.activated?
        return true
      end
    end
    false
  end

  def user_is_subscribed_to_delivery?(delivery)
    @subscriptions.each do |s|
      if s.delivery == delivery && s.activated?
        return true
      end
    end
    false
  end

end
