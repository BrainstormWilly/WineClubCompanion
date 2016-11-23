class Api::V1::SubscriptionsController < Api::V1::BaseController

  def index
    subscriptions = policy_scope(Subscription)
    render json: subscriptions, each_serializer: SubscriptionSerializer
  end

  def update
    subscription = Subscription.find(params[:id])
    authorize subscription
    subscription.assign_attributes(update_subscription_params)
    if subscription.save
      render json: subscription
    else
      render json: { error: "Unknown Error", status: 400 }, status: 400
    end
  end


  private

  def update_subscription_params
    params.require(:subscription).permit(:activated)
  end

end
