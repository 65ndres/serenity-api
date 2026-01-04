class Conversation < ApplicationRecord
  has_many :user_conversations, dependent: :destroy
  has_many :users, through: :user_conversations
  has_many :messages, dependent: :destroy
  has_many :admin_messages, dependent: :destroy

  # Find or create a conversation between two users
  def self.between(user1, user2)
    # Find conversations that have both users (exactly these two)
    joins(:users)
      .where(users: { id: [user1.id, user2.id] })
      .group('conversations.id')
      .having('COUNT(DISTINCT users.id) = ?', 2)
      .first
  end

  # Get the other user(s) in the conversation (excluding the given user)
  def other_users(user)
    users.where.not(id: user.id)
  end

  # Get the other user in a two-person conversation
  def other_user(user)
    other_users = users.where.not(id: user.id)
    other_users.first if other_users.count == 1
  end
end


