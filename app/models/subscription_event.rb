class SubscriptionEvent < ApplicationRecord
  belongs_to :user
  belongs_to :subscription

  enum event_type: { payment_succeeded: 0, payment_failed: 1, subscription_canceled: 2, subscription_updated: 3 }

  validates :processor_event_id, presence: true, uniqueness: true
end