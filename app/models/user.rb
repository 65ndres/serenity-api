class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher

  devise :database_authenticatable, :registerable, :recoverable, :validatable, :jwt_authenticatable, jwt_revocation_strategy: self

  has_many :user_interactions, dependent: :destroy
  has_many :liked_verses, -> { where(user_interactions: { liked: true }) }, through: :user_interactions, source: :verse

  # Messaging associations
  has_many :user_conversations, dependent: :destroy
  has_many :conversations, through: :user_conversations
  has_many :sent_messages, class_name: 'Message', foreign_key: 'sender_id', dependent: :destroy
  has_many :received_messages, class_name: 'Message', foreign_key: 'receiver_id', dependent: :destroy

  validates :username, presence: true, uniqueness: true, allow_nil: true

  # Search users by username
  scope :search_by_username, ->(query) { where('username ILIKE ?', "%#{query}%") }
end