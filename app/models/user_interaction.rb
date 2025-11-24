class UserInteraction < ApplicationRecord
  belongs_to :user
  belongs_to :verse

  validates :user_id, uniqueness: { scope: :verse_id, message: "has already interacted with this verse" }
  validates :liked, inclusion: { in: [true, false] }
end
