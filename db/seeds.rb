data = [
  {
    "book": "John",
    "chapter": 3,
    "verse": 16,
    "liked": false,
    "favorited": false,
    "text": "For God so loved the world, that he gave his only begotten Son, that whosoever believeth in him should not perish, but have everlasting life."
  },
  {
    "book": "Psalms",
    "chapter": 23,
    "verse": 1,
    "liked": false,
    "favorited": false,
    "text": "The Lord is my shepherd; I shall not want."
  },
  {
    "book": "Proverbs",
    "chapter": 3,
    "verse": 5,
    "liked": false,
    "favorited": false,
    "text": "Trust in the Lord with all thine heart; and lean not unto thine own understanding."
  },
  {
    "book": "Romans",
    "chapter": 8,
    "verse": 28,
    "liked": false,
    "favorited": false,
    "text": "And we know that all things work together for good to them that love God, to them who are the called according to his purpose."
  },
  {
    "book": "Philippians",
    "chapter": 4,
    "verse": 13,
    "liked": false,
    "favorited": false,
    "text": "I can do all things through Christ which strengtheneth me."
  },
  {
    "book": "Genesis",
    "chapter": 1,
    "verse": 1,
    "liked": false,
    "favorited": false,
    "text": "In the beginning God created the heaven and the earth."
  },
  {
    "book": "Matthew",
    "chapter": 6,
    "verse": 33,
    "liked": false,
    "favorited": false,
    "text": "But seek ye first the kingdom of God, and his righteousness; and all these things shall be added unto you."
  },
  {
    "book": "Isaiah",
    "chapter": 40,
    "verse": 31,
    "liked": false,
    "favorited": false,
    "text": "But they that wait upon the Lord shall renew their strength; they shall mount up with wings as eagles; they shall run, and not be weary; and they shall walk, and not faint."
  },
  {
    "book": "1 Corinthians",
    "chapter": 13,
    "verse": 4,
    "liked": false,
    "favorited": false,
    "text": "Charity suffereth long, and is kind; charity envieth not; charity vaunteth not itself, is not puffed up."
  },
  {
    "book": "Jeremiah",
    "chapter": 29,
    "verse": 11,
    "liked": false,
    "favorited": false,
    "text": "For I know the thoughts that I think toward you, saith the Lord, thoughts of peace, and not of evil, to give you an expected end."
  }
]

data.each do |d|
  Verse.create!(text: d[:text], book: d[:book], chapter: d[:chapter], favorite: d[:favorited], verse: d[:verse])
end