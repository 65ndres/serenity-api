class Message < ApplicationRecord
  belongs_to :conversation
  belongs_to :sender, class_name: 'User'

  has_one :verse

  scope :unread, -> { where(read: false) }
  scope :read, -> { where(read: true) }
end

