# app/models/user.rb
class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable, :jwt_authenticatable, jwt_revocation_strategy: JwtDenylist
  # pay_customer # Adds stripe_customer_id, payment methods, etc.

  # has_many :subscriptions
  # has_many :subscription_events # For audit logs

  # def active_subscription?
  #   subscriptions.exists?(status: :active)
  # end
end