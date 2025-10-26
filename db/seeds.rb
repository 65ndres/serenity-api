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





# db/seeds.rb
user = User.create(email: 'test@example.com', password: 'password', password_confirmation: 'password')
tag1 = Tag.create(name: 'Faith')
tag2 = Tag.create(name: 'Hope')
tag3 = Tag.create(name: 'Love')

verses = Verse.create([
  { book: 'Genesis', chapter: 1, verse: 1, text: 'In the beginning God created the heavens and the earth.', liked: false, favorited: false, user: user },
  { book: 'Genesis', chapter: 1, verse: 2, text: 'The earth was formless and empty...', liked: true, favorited: false, user: user },
  { book: 'Genesis', chapter: 1, verse: 3, text: 'And God said, "Let there be light," and there was light.', liked: false, favorited: true, user: user },
])

verses[0].tags = [tag1, tag2] # Genesis 1:1 has Faith, Hope
verses[1].tags = [tag2, tag3] # Genesis 1:2 has Hope, Love
verses[2].tags = [tag1, tag3] # Genesis 1:3 has Faith, Love



# store real data:

anxiety_tag = Tag.create(name: 'Anxiety')
acceptance_tag = Tag.create(name: 'Acceptance')
belief_tag = Tag.create(name: 'Belief')
blessings_tag = Tag.create(name: 'Blessings')
confidence_tag = Tag.create(name: 'Confidence')
courage_tag = Tag.create(name: 'Courage')


bible = {
  "Corinthians": {
    "16": {
      "13": {
        "NCV": "Be alert. Continue strong in the faith.",
        "tags": [courage_tag]
      },
      "14": {
        "NCV": "Have courage, and be strong. Do everyhing in love.",
        "tags": [courage_tag]
      }
    }
  },
  "Ephesians": {
    "1": {
      "3": {
        "NIRV": "Give praise to the God and Father of our Lord Jesus Christ. He has blessed us with every spiritual blessing. Those blessings come from the heavenly world. The belong to us because we belong to Christ."
      },
      "4": {
        "TLB": "Before he made the world. God chose us to be his very own through what Christ would do for us; he decided then to make us holy in his eyes, without a single fault-we who stand before him covered wiht his love.",
        "tags": [acceptance_tag]
      }
    },
    "6": {
      "10": {
        "NIV": "Be strong in the Lord and in his mighty power.",
        "tags": [courage_tag]
      },
      "11": {
        "NIV": "Put on the full armor of God. so that you can take your stand against the devil's schemes.",
        "tags": [courage_tag]
      }
    }
  },
  "Hebrews": {
    "10": {
      "35": {
        "NCV": "Do not throw away your confidence, which has great reward",
        "tags": [confidence_tag]
      }
    }
  },
  "Isaiah": {
    "26": {
      "3": {
        "NIV": "You will keep in perfect peace those whose minds are steadfast, because they trust in you.",
        "tags": [anxiety_tag]
      }
    }
  },
  "John": {
    "1": {
      "12": {
        "NCV": "To all who did accept him and believe in him he gave me the right to become children of God.",
        "tags": [belief_tag]
      }
    },
    "6": {
      "37": {
        "NCV": '"The Father gives me the people who are mine. Every one of them will come to me, and I will always accept them."',
        "tags": [acceptance_tag]
      }
    },
    "14": {
      "1": {
        "NLT": '"Don\'d let your hearts be troubled. Trust in God, and trust also in me."',
        "tags": [anxiety_tag]
      }
    },
    "20": {
      "29": {
        "ESV": '"Have you believed because you have seen me? Blessed are those who have not seen and yet have believed."',
        "tags": [belief_tag]
      }
    }
  },
  "Joshua": {
    "1": {
      "9": {
        "NLT": '"This is my command-be strong and courageous! Donor be afraid or discouraged. For the LORD your God is with you wherever you go."',
        "tags": [courage_tag]
      }
    }
  },
  "Mark": {
    "9": {
      "23": {
        "NASB": '"All things are possible to him who believes."',
        "tags": [belief_tag]
      }
    }
  },
  "Peter": {
    "5": {
      "7": {
        "NIRV": "Give all your worries to him, because he cares about you.",
        "tags": [anxiety_tag]
      }
    }
  },
  "Philippians": {
    "4": {
      "13": {
        "NLT": "I can do everything throught Christ, who gives me strenght.",
        "tags": [confidence_tag]
      }
    }
  },
  "Psalms": {
    "5": {
      "12": {
        "NIRV": "Surely, LORD. you bless those who do what is right. Like a shield, your loving care keeps them safe.",
        "tags": [blessings_tag]
      }
    },
    "21": {
      "6": {
        "NIV": "Surely you have granted him unending blessings and made him glad with the joy of your presence."
      }
    },
    "23": {
      "4": {
        "NIRV": "Even though I walk thought the darkest valley, I will not be afraid. You are with me. Your sheperd's rod and staff confort me.",
        "tags": [courage_tag]
      }
    },
    "71": {
      "3": {
        "NJV": "Be my rock of refuge, to which I can always go",
        "tags": [confidence_tag]
      },
      "4": {
        "NJV": "Give me the command to save, for you are my rock and my fortress...",
        "tags": [confidence_tag]
      },
      "5": {
        "NJV": "For you have been my hope, Soverign LORD, my confidence since my youth.",
        "tags": [confidence_tag]
      }
    },
    "120": {
      "1": {
       "NIRV": "I call out to the LORD when I'm in trouble, and he answers me.",
       "tags": [anxiety_tag]
      }
    }
  },
  "Samuel": {
    "16": {
      "7": {
        "NKJV": "The LORD does not see as man sees; for man looks at the ourward appearence, but the LORD looks at the heart",
        "tags": [acceptance_tag]
      }
    }
  },
  "Timothy": {
    "4": {
      "6": {
        "NKJV": "If you  instruct the brethren in these things, you will be a good minister of Jesus Christ, nourished in the words of faith and the good doctrine which you have carefully followed.",
        "tags": [belief_tag]
      }
    }
  }
}
