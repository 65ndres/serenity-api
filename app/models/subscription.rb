# app/models/subscription.rb
class Subscription < ApplicationRecord
  belongs_to :user
  belongs_to :plan

  enum status: { active: 0, canceled: 1, past_due: 2, trial: 3 }
  enum processor: { apple: 0, google: 1, stripe: 2 }

  validates :processor_id, presence: true # e.g., Apple transaction ID, Google purchase token, Stripe subscription ID
  validates :plan_id, presence: true

  def active?
    status == 'active'
  end

  def sync_with_processor
    case processor
    when 'stripe'
      stripe_subscription = Stripe::Subscription.retrieve(processor_id)
      self.status = stripe_subscription.status
      self.current_period_end = Time.at(stripe_subscription.current_period_end)
    when 'apple'
      # Validate receipt with Apple (StoreKit or server-side)
      # Update status, current_period_end based on receipt
    when 'google'
      # Validate purchase token with Google Play Billing
      # Update status, current_period_end
    end
    save!
  end
end