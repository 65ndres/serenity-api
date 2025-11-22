anxiety_tag = Tag.find_or_create_by(name: 'Anxiety')
acceptance_tag = Tag.find_or_create_by(name: 'Acceptance')
belief_tag = Tag.find_or_create_by(name: 'Belief')
blessings_tag = Tag.find_or_create_by(name: 'Blessings')
confidence_tag = Tag.find_or_create_by(name: 'Confidence')
courage_tag = Tag.find_or_create_by(name: 'Courage')

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
        "NIRV": "Give praise to the God and Father of our Lord Jesus Christ. He has blessed us with every spiritual blessing. Those blessings come from the heavenly world. The belong to us because we belong to Christ.",
        "tags": [acceptance_tag]
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
      },
      "27": {
        "OEB": "Peace be with you! My own peace I give you. I do not give to you as the world gives. Do not let your hearts be troubled, or dismayed"
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
        "NIV": "Surely you have granted him unending blessings and made him glad with the joy of your presence.",
        "tags": [blessings_tag]
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
        "tags": [anxiety_tag, belief_tag]
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
  },
  "2 Timothy": {
    "1": {
      "7": {
        "OEB": "For the Spirit which God gave us was not a spirit of cowardice, but a spirit of power, love, and self-control",
        "tags": [anxiety_tag, courage_tag]
      }
    }
  }

}

bible.each do |book, chapter| 
  chapter.each do | chapter, verse|
    verse.each do |verse, text_and_tags|
      tags = text_and_tags.delete(:tags)
      text_and_tags.each do |source, text|
        Verse.create!(book:, chapter: chapter.to_s.to_i, verse: verse.to_s.to_i, source: source.to_s, text:, tags:)
      end
    end
  end
end



Timothy 1:7


