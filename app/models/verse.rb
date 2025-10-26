class Verse < ApplicationRecord

  validates :book ,presence: true
  validates :chapter ,presence: true
  validates :verse, presence: true
  validates :text, presence: true

  enum book: [
    :Genesis, :Exodus, :Leviticus, :Numbers, :Deuteronomy, :Joshua, :Judges, :Ruth,
    :"Samuel", :"2 Samuel", :"1 Kings", :"2 Kings", :"1 Chronicles", :"2 Chronicles",
    :Ezra, :Nehemiah, :Esther, :Job, :Psalms, :Proverbs, :Ecclesiastes, :"Song of Solomon",
    :Isaiah, :Jeremiah, :Lamentations, :Ezekiel, :Daniel, :Hosea, :Joel, :Amos, :Obadiah,
    :Jonah, :Micah, :Nahum, :Habakkuk, :Zephaniah, :Haggai, :Zechariah, :Malachi,
    :Matthew, :Mark, :Luke, :John, :Acts, :Romans, :"Corinthians", :"2 Corinthians",
    :Galatians, :Ephesians, :Philippians, :Colossians, :"1 Thessalonians", :"2 Thessalonians",
    :"Timothy", :"2 Timothy", :Titus, :Philemon, :Hebrews, :James, :"Peter", :"2 Peter",
    :"1 John", :"2 John", :"3 John", :Jude, :Revelation
  ]
  has_many :verse_tags, dependent: :destroy
  has_many :tags, through: :verse_tags
end
