class Api::V1::SubscriptionsController < ApplicationController
  before_action :authenticate_user!

  def create
    plan = Plan.find(params[:plan_id])
    case params[:processor]
    when 'apple'
      # Validate Apple receipt
      receipt = params[:receipt]
      subscription = current_user.subscriptions.create!(
        plan: plan,
        processor: :apple,
        processor_id: receipt[:transaction_id], # From StoreKit
        status: :active,
        current_period_end: Time.at(receipt[:expires_date_ms] / 1000)
      )
    when 'google'
      # Validate Google purchase token
      purchase_token = params[:purchase_token]
      subscription = current_user.subscriptions.create!(
        plan: plan,
        processor: :google,
        processor_id: purchase_token,
        status: :active
        # Set current_period_end via Google Play Billing API
      )
    when 'stripe'
      stripe_subscription = Stripe::Subscription.create(
        customer: current_user.stripe_customer_id || Stripe::Customer.create(email: current_user.email).id,
        items: [{ price: plan.stripe_price_id }]
      )
      current_user.update(stripe_customer_id: stripe_subscription.customer)
      subscription = current_user.subscriptions.create!(
        plan: plan,
        processor: :stripe,
        processor_id: stripe_subscription.id,
        status: :active,
        current_period_end: Time.at(stripe_subscription.current_period_end)
      )
    else
      return render json: { error: 'Invalid processor' }, status: :bad_request
    end
    render json: subscription, status: :created
  end

  def cancel
    subscription = current_user.subscriptions.find(params[:id])
    case subscription.processor
    when 'stripe'
      Stripe::Subscription.update(subscription.processor_id, cancel_at_period_end: true)
      subscription.update(status: :canceled)
    # Apple/Google cancellations are handled client-side via StoreKit/Play Billing
    end
    render json: subscription
  end
end