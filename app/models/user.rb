class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher

  devise :database_authenticatable, :registerable, :recoverable, :validatable, :jwt_authenticatable, jwt_revocation_strategy: self

  has_many :user_interactions, dependent: :destroy
  has_many :liked_verses, -> { where(user_interactions: { liked: true }) }, through: :user_interactions, source: :verse
end