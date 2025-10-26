class VerseTag < ApplicationRecord
  belongs_to :verse
  belongs_to :tag
end
