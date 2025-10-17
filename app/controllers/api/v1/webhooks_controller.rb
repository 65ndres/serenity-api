class Api::V1::WebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token
  skip_before_action :authenticate_user!

  def stripe
    payload = request.body.read
    sig_header = request.env['HTTP_STRIPE_SIGNATURE']
    event = Stripe::Webhook.construct_event(payload, sig_header, ENV['STRIPE_WEBHOOK_SECRET'])

    case event.type
    when 'invoice.payment_succeeded'
      subscription = Subscription.find_by(processor: 'stripe', processor_id: event.data.object.subscription)
      subscription.update(status: :active, current_period_end: Time.at(event.data.object.period_end))
      subscription.subscription_events.create(
        event_type: :payment_succeeded,
        processor_event_id: event.id,
        data: event.to_json
      )
    when 'invoice.payment_failed'
      subscription = Subscription.find_by(processor: 'stripe', processor_id: event.data.object.subscription)
      subscription.update(status: :past_due)
      subscription.subscription_events.create(
        event_type: :payment_failed,
        processor_event_id: event.id,
        data: event.to_json
      )
    when 'customer.subscription.deleted'
      subscription = Subscription.find_by(processor: 'stripe', processor_id: event.data.object.id)
      subscription.update(status: :canceled)
      subscription.subscription_events.create(
        event_type: :subscription_canceled,
        processor_event_id: event.id,
        data: event.to_json
      )
    end
    head :ok
  rescue Stripe::SignatureVerificationError => e
    head :unauthorized
  end

  def apple
    # Validate Apple server notification
    notification = JSON.parse(request.body.read)
    subscription = Subscription.find_by(processor: 'apple', processor_id: notification['transaction_id'])
    case notification['notification_type']
    when 'RENEWAL'
      subscription.update(status: :active, current_period_end: Time.at(notification['expires_date_ms'] / 1000))
      subscription.subscription_events.create(
        event_type: :payment_succeeded,
        processor_event_id: notification['notification_uuid'],
        data: notification.to_json
      )
    when 'CANCEL'
      subscription.update(status: :canceled)
      subscription.subscription_events.create(
        event_type: :subscription_canceled,
        processor_event_id: notification['notification_uuid'],
        data: notification.to_json
      )
    end
    head :ok
  end

  def google
    # Validate Google RTDN
    notification = JSON.parse(request.body.read)
    subscription = Subscription.find_by(processor: 'google', processor_id: notification['purchase_token'])
    case notification['subscriptionNotification']['notificationType']
    when 2 # SUBSCRIPTION_PURCHASED or SUBSCRIPTION_RENEWED
      subscription.update(status: :active, current_period_end: Time.at(notification['subscriptionNotification']['eventTimeMillis'] / 1000))
      subscription.subscription_events.create(
        event_type: :payment_succeeded,
        processor_event_id: notification['messageId'],
        data: notification.to_json
      )
    when 3 # SUBSCRIPTION_CANCELED
      subscription.update(status: :canceled)
      subscription.subscription_events.create(
        event_type: :subscription_canceled,
        processor_event_id: notification['messageId'],
        data: notification.to_json
      )
    end
    head :ok
  end
end