class Plan < ApplicationRecord
  has_many :subscriptions

  validates :name, presence: true
  validates :amount, numericality: { greater_than_or_equal_to: 0 }
  validates :interval, inclusion: { in: %w[month year] }

  def sync_with_stripe
    return unless stripe_price_id
    stripe_price = Stripe::Price.retrieve(stripe_price_id)
    self.amount = stripe_price.unit_amount / 100.0
    self.currency = stripe_price.currency
    self.interval = stripe_price.recurring.interval
    save!
  end
end
