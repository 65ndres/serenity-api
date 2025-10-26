class Tag < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  # belongs_to :verse, optional: true
end