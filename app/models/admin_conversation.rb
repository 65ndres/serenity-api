class AdminConversation < ApplicationRecord
  belongs_to :user

  validates :body, presence: true

  scope :unread, -> { where(read: false) }
  scope :read, -> { where(read: true) }
end

