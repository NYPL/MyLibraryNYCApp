# frozen_string_literal: true

ENV['RAILS_ENV'] = 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'webmock/test_unit'
require 'factories/user_factory'
require 'factories/school_factory'
require 'factories/book_factory'
require 'factories/teacher_set_factory'
require 'pry'
require 'pry-stack_explorer'

include WebMock::API

WebMock.disable_net_connect!(allow_localhost: true)

require 'minitest'
require 'minitest/assertions'
require 'minitest/autorun'
require 'stringio'

require 'active_support'
require 'active_support/core_ext'
require 'logger'

MODIFIED_BOOK_JSON_FOR_ISBN_9782917623268 = '{
  "data": [
    {
      "id": "18888888",
      "nyplSource": "sierra-nypl",
      "nyplType": "bib",
      "updatedDate": "2016-02-15T03:03:46-05:00",
      "createdDate": "2011-03-31T14:07:37-04:00",
      "deletedDate": null,
      "deleted": false,
      "locations": [
        {
          "code": "bca",
          "name": "Bronx Library Center Adult"
        }
      ],
      "suppressed": false,
      "lang": {
        "code": "fre",
        "name": "French"
      },
      "title": "Pasé on bel Nwel lieutenant Simeoni! : roman policier",
      "author": "Arrighi, Olivier.",
      "materialType": {
        "code": "a",
        "value": "BOOK/TEXT"
      },
      "bibLevel": {
        "code": "m",
        "value": "MONOGRAPH"
      },
      "publishYear": 2010,
      "catalogDate": "2011-03-31",
      "country": {
        "code": "fr ",
        "name": "France"
      },
      "normTitle": "pasé on bel nwel lieutenant simeoni roman policier",
      "normAuthor": "arrighi olivier",
      "standardNumbers": [
        "9782917623268",
        "2917623268"
      ],
      "controlNumber": "696084229",
      "fixedFields": {
        "24": {
          "label": "Language",
          "value": "fre",
          "display": "French"
        },
        "25": {
          "label": "Skip",
          "value": "0",
          "display": null
        },
        "26": {
          "label": "Location",
          "value": "bca  ",
          "display": "Bronx Library Center Adult"
        },
        "27": {
          "label": "COPIES",
          "value": "2",
          "display": null
        },
        "28": {
          "label": "Cat. Date",
          "value": "2011-03-31",
          "display": null
        },
        "29": {
          "label": "Bib Level",
          "value": "m",
          "display": "MONOGRAPH"
        },
        "30": {
          "label": "Material Type",
          "value": "a",
          "display": "BOOK/TEXT"
        },
        "31": {
          "label": "Bib Code 3",
          "value": "-",
          "display": null
        },
        "80": {
          "label": "Record Type",
          "value": "b",
          "display": null
        },
        "81": {
          "label": "Record Number",
          "value": "18888888",
          "display": null
        },
        "83": {
          "label": "Created Date",
          "value": "2011-03-31T14:07:37Z",
          "display": null
        },
        "84": {
          "label": "Updated Date",
          "value": "2016-02-15T03:03:46Z",
          "display": null
        },
        "85": {
          "label": "No. of Revisions",
          "value": "6",
          "display": null
        },
        "86": {
          "label": "Agency",
          "value": "1",
          "display": null
        },
        "89": {
          "label": "Country",
          "value": "fr ",
          "display": "France"
        },
        "98": {
          "label": "PDATE",
          "value": "2016-02-14T06:26:14Z",
          "display": null
        },
        "107": {
          "label": "MARC Type",
          "value": " ",
          "display": null
        }
      },
      "varFields": [
        {
          "fieldTag": "n",
          "marcTag": "520",
          "ind1": " ",
          "ind2": " ",
          "content": null,
          "subfields": [
            {
              "tag": "a",
              "content": "Despite the medical miracle that has bought her a few more years, Hazel has never been anything but terminal, but when Augustus Waters suddenly appears at the Cancer Kid Support Group, Hazels story is about to be rewritten."
            }
          ]
        },
        {
          "fieldTag": "a",
          "marcTag": "100",
          "ind1": "1",
          "ind2": " ",
          "content": null,
          "subfields": [
            {
              "tag": "a",
              "content": "Arrighi, Olivier."
            }
          ]
        },
        {
          "fieldTag": "c",
          "marcTag": "091",
          "ind1": " ",
          "ind2": " ",
          "content": null,
          "subfields": [
            {
              "tag": "p",
              "content": "Fre"
            },
            {
              "tag": "a",
              "content": "FIC"
            },
            {
              "tag": "c",
              "content": "A"
            }
          ]
        },
        {
          "fieldTag": "i",
          "marcTag": "020",
          "ind1": " ",
          "ind2": " ",
          "content": null,
          "subfields": [
            {
              "tag": "a",
              "content": "9782917623268 (pbk.)"
            }
          ]
        },
        {
          "fieldTag": "i",
          "marcTag": "020",
          "ind1": " ",
          "ind2": " ",
          "content": null,
          "subfields": [
            {
              "tag": "a",
              "content": "2917623268 (pbk.)"
            }
          ]
        },
        {
          "fieldTag": "l",
          "marcTag": "035",
          "ind1": " ",
          "ind2": " ",
          "content": null,
          "subfields": [
            {
              "tag": "a",
              "content": "(OCoLC)696084229"
            }
          ]
        },
        {
          "fieldTag": "o",
          "marcTag": "001",
          "ind1": " ",
          "ind2": " ",
          "content": "696084229",
          "subfields": null
        },
        {
          "fieldTag": "p",
          "marcTag": "260",
          "ind1": " ",
          "ind2": " ",
          "content": null,
          "subfields": [
            {
              "tag": "a",
              "content": "Lamentin :"
            },
            {
              "tag": "b",
              "content": "Caraïbéditions,"
            },
            {
              "tag": "c",
              "content": "c2010."
            }
          ]
        },
        {
          "fieldTag": "r",
          "marcTag": "300",
          "ind1": " ",
          "ind2": " ",
          "content": null,
          "subfields": [
            {
              "tag": "a",
              "content": "236 p. ;"
            },
            {
              "tag": "c",
              "content": "22 cm."
            }
          ]
        },
        {
          "fieldTag": "s",
          "marcTag": "490",
          "ind1": "0",
          "ind2": " ",
          "content": null,
          "subfields": [
            {
              "tag": "a",
              "content": "Polar"
            }
          ]
        },
        {
          "fieldTag": "t",
          "marcTag": "245",
          "ind1": "1",
          "ind2": "0",
          "content": null,
          "subfields": [
            {
              "tag": "a",
              "content": "Pasé on bel Nwel lieutenant Simeoni! :"
            },
            {
              "tag": "b",
              "content": "roman policier /"
            },
            {
              "tag": "c",
              "content": "Olivier Arrighi."
            }
          ]
        },
        {
          "fieldTag": "y",
          "marcTag": "003",
          "ind1": " ",
          "ind2": " ",
          "content": "OCoLC",
          "subfields": null
        },
        {
          "fieldTag": "y",
          "marcTag": "005",
          "ind1": " ",
          "ind2": " ",
          "content": "20110330110134.0",
          "subfields": null
        },
        {
          "fieldTag": "y",
          "marcTag": "008",
          "ind1": " ",
          "ind2": " ",
          "content": "101229s2010    fr     g      000 1 fre dnamIa ",
          "subfields": null
        },
        {
          "fieldTag": "y",
          "marcTag": "040",
          "ind1": " ",
          "ind2": " ",
          "content": null,
          "subfields": [
            {
              "tag": "a",
              "content": "AUXAM"
            },
            {
              "tag": "c",
              "content": "AUXAM"
            },
            {
              "tag": "d",
              "content": "NYP"
            }
          ]
        },
        {
          "fieldTag": "y",
          "marcTag": "049",
          "ind1": " ",
          "ind2": " ",
          "content": null,
          "subfields": [
            {
              "tag": "a",
              "content": "NYPP"
            }
          ]
        },
        {
          "fieldTag": "y",
          "marcTag": "901",
          "ind1": " ",
          "ind2": " ",
          "content": null,
          "subfields": [
            {
              "tag": "a",
              "content": "rbf"
            },
            {
              "tag": "b",
              "content": "CMC"
            },
            {
              "tag": "c",
              "content": "CATBL"
            }
          ]
        },
        {
          "fieldTag": "y",
          "marcTag": "901",
          "ind1": " ",
          "ind2": " ",
          "content": null,
          "subfields": [
            {
              "tag": "a",
              "content": "MARS"
            }
          ]
        },
        {
          "fieldTag": "y",
          "marcTag": "946",
          "ind1": " ",
          "ind2": " ",
          "content": null,
          "subfields": [
            {
              "tag": "a",
              "content": "m"
            }
          ]
        },
        {
          "fieldTag": "y",
          "marcTag": "949",
          "ind1": " ",
          "ind2": "1",
          "content": null,
          "subfields": [
            {
              "tag": "l",
              "content": "wfa0l"
            },
            {
              "tag": "i",
              "content": "33333804031256"
            },
            {
              "tag": "t",
              "content": "102"
            },
            {
              "tag": "s",
              "content": "b"
            },
            {
              "tag": "p",
              "content": "$10.00"
            },
            {
              "tag": "v",
              "content": "CATBL/CMC/rbf"
            }
          ]
        },
        {
          "fieldTag": "y",
          "marcTag": "949",
          "ind1": " ",
          "ind2": "1",
          "content": null,
          "subfields": [
            {
              "tag": "l",
              "content": "bca0l"
            },
            {
              "tag": "i",
              "content": "33333804031249"
            },
            {
              "tag": "t",
              "content": "102"
            },
            {
              "tag": "s",
              "content": "b"
            },
            {
              "tag": "p",
              "content": "$10.00"
            },
            {
              "tag": "v",
              "content": "CATBL/CMC/rbf"
            }
          ]
        },
        {
          "fieldTag": "_",
          "marcTag": null,
          "ind1": null,
          "ind2": null,
          "content": "00000nam  2200301Ia 4500",
          "subfields": null
        }
      ]
    }
  ],
  "count": 1,
  "totalCount": 0,
  "statusCode": 200,
  "debugInfo": []
}'

BNUMBER1 = "998"
BNUMBER2 = "999"

TWO_TEACHER_SETS_WITH_10_ISBNS_EACH = [
  {
    "id": "#{BNUMBER1}",
    "nyplSource": "sierra-nypl",
    "nyplType": "bib",
    "updatedDate": "2017-08-23T20:22:13-04:00",
    "createdDate": "2017-08-23T14:46:46-04:00",
    "deletedDate": nil,
    "deleted": false,
    "locations": [
      {
        "code": "ed",
        "name": "LSC Educator Collection"
      }
    ],
    "suppressed": false,
    "lang": {
      "code": "eng",
      "name": "English"
    },
    "title": "Books for Reading and Sharing - Elementary School! 1",
    "author": "",
    "materialType": {
      "code": "8",
      "value": "TEACHER SET"
    },
    "bibLevel": {
      "code": "m",
      "value": "MONOGRAPH"
    },
    "publishYear": nil,
    "catalogDate": "2017-08-23",
    "country": {
      "code": "xx ",
      "name": "Unknown or undetermined"
    },
    "normTitle": "books for reading and sharing elementary school",
    "normAuthor": "",
    "standardNumbers": [],
    "controlNumber": "",
    "fixedFields": {
      "24": {
        "label": "Language",
        "value": "eng",
        "display": "English"
      },
      "25": {
        "label": "Skip",
        "value": "0",
        "display": nil
      },
      "26": {
        "label": "Location",
        "value": "ed   ",
        "display": "LSC Educator Collection"
      },
      "27": {
        "label": "COPIES",
        "value": "0",
        "display": nil
      },
      "28": {
        "label": "Cat. Date",
        "value": "2017-08-23",
        "display": nil
      },
      "29": {
        "label": "Bib Level",
        "value": "m",
        "display": "MONOGRAPH"
      },
      "30": {
        "label": "Material Type",
        "value": "8",
        "display": "TEACHER SET"
      },
      "31": {
        "label": "Bib Code 3",
        "value": "-",
        "display": nil
      },
      "80": {
        "label": "Record Type",
        "value": "b",
        "display": nil
      },
      "81": {
        "label": "Record Number",
        "value": "21323534",
        "display": nil
      },
      "83": {
        "label": "Created Date",
        "value": "2017-08-23T14:46:46Z",
        "display": nil
      },
      "84": {
        "label": "Updated Date",
        "value": "2017-08-23T20:22:13Z",
        "display": nil
      },
      "85": {
        "label": "No. of Revisions",
        "value": "2",
        "display": nil
      },
      "86": {
        "label": "Agency",
        "value": "1",
        "display": nil
      },
      "89": {
        "label": "Country",
        "value": "xx ",
        "display": "Unknown or undetermined"
      },
      "98": {
        "label": "PDATE",
        "value": "2017-08-23T20:20:00Z",
        "display": nil
      },
      "107": {
        "label": "MARC Type",
        "value": " ",
        "display": nil
      }
    },
    "varFields": [
      {
        "fieldTag": "c",
        "marcTag": "091",
        "ind1": " ",
        "ind2": " ",
        "content": nil,
        "subfields": [
          {
            "tag": "a",
            "content": "Teacher Set ELA A Books 4"
          }
        ]
      },
      {
        "fieldTag": "d",
        "marcTag": "650",
        "ind1": " ",
        "ind2": "1",
        "content": nil,
        "subfields": [
          {
            "tag": "a",
            "content": "Political activists."
          }
        ]
      },
      {
        "fieldTag": "d",
        "marcTag": "650",
        "ind1": " ",
        "ind2": "1",
        "content": nil,
        "subfields": [
          {
            "tag": "a",
            "content": "Race relations."
          }
        ]
      },
      {
        "fieldTag": "d",
        "marcTag": "690",
        "ind1": "0",
        "ind2": "7",
        "content": nil,
        "subfields": [
          {
            "tag": "a",
            "content": "English Language Arts."
          },
          {
            "tag": "2",
            "content": "local"
          }
        ]
      },
      {
        "fieldTag": "n",
        "marcTag": "500",
        "ind1": " ",
        "ind2": " ",
        "content": nil,
        "subfields": [
          {
            "tag": "a",
            "content": "2 copies of 10 titles."
          }
        ]
      },
      {
        "fieldTag": "n",
        "marcTag": "505",
        "ind1": " ",
        "ind2": " ",
        "content": nil,
        "subfields": [
          {
            "tag": "a",
            "content": "Anna carries water -- Monkey & Robot -- Mother Bruce -- The book with no pictures -- The day the crayons quit -- The scraps book : notes from a colorful life -- Three bears in a boat -- Blizzard -- Bright Sky, Starry City -- Hula-Hoopin Queen."
          }
        ]
      },
      {
        "fieldTag": "n",
        "marcTag": "520",
        "ind1": " ",
        "ind2": " ",
        "content": nil,
        "subfields": [
          {
            "tag": "a",
            "content": "Topic Set (20 books) - This set of titles are great for reading aloud and sharing in the classroom - grades 1 and grades 2.  These titles were former selections from the NYC Department of Education NYC Reads 365 list."
          }
        ]
      },
      {
        "fieldTag": "e",
        "marcTag": "250",
        "ind1": " ",
        "ind2": " ",
        "content": nil,
        "subfields": [
          {
            "tag": "a",
            "content": "1st Hyperion Paperbacks ed."
          }
        ]
      },
      {
        "fieldTag": "i",
        "marcTag": "020",
        "ind1": " ",
        "ind2": " ",
        "content": nil,
        "subfields": [
          {
            "tag": "a",
            "content": "9781489813930"
          }
        ]
      },
      {
        "fieldTag": "p",
        "marcTag": "260",
        "ind1": " ",
        "ind2": " ",
        "content": nil,
        "subfields": [
          {
            "tag": "a",
            "content": "McHenry, Ill. :"
          },
          {
            "tag": "b",
            "content": "Follett Library Resources,"
          },
          {
            "tag": "c",
            "content": "2013."
          }
        ]
      },
      {
        "fieldTag": "n",
        "marcTag": "521",
        "ind1": "2",
        "ind2": " ",
        "content": nil,
        "subfields": [
          {
            "tag": "a",
            "content": "K-1."
          }
        ]
      },
      {
        "fieldTag": "n",
        "marcTag": "521",
        "ind1": "2",
        "ind2": " ",
        "content": nil,
        "subfields": [
          {
            "tag": "a",
            "content": "1-2."
          }
        ]
      },
      {
        "fieldTag": "n",
        "marcTag": "521",
        "ind1": "8",
        "ind2": " ",
        "content": nil,
        "subfields": [
          {
            "tag": "a",
            "content": "70L-500L"
          },
          {
            "tag": "b",
            "content": "Lexile"
          }
        ]
      },
      {
        "fieldTag": "r",
        "marcTag": "300",
        "ind1": " ",
        "ind2": " ",
        "content": nil,
        "subfields": [
          {
            "tag": "a",
            "content": "20 v."
          }
        ]
      },
      {
        "fieldTag": "s",
        "marcTag": "490",
        "ind1": "0",
        "ind2": " ",
        "content": nil,
        "subfields": [
          {
            "tag": "a",
            "content": "Teacher Sets: MyLibraryNYC Program"
          }
        ]
      },
      {
        "fieldTag": "t",
        "marcTag": "245",
        "ind1": "0",
        "ind2": "0",
        "content": nil,
        "subfields": [
          {
            "tag": "a",
            "content": "Books for Reading and Sharing - Elementary School! 2"
          }
        ]
      },
      {
        "fieldTag": "u",
        "marcTag": "246",
        "ind1": "3",
        "ind2": "0",
        "content": nil,
        "subfields": [
          {
            "tag": "a",
            "content": "English Language Arts: Books for Reading and Sharing - Elementary School! Gr. 1-2 (Teacher Set)."
          }
        ]
      },
      {
        "fieldTag": "y",
        "marcTag": "901",
        "ind1": " ",
        "ind2": " ",
        "content": nil,
        "subfields": [
          {
            "tag": "a",
            "content": "ed"
          },
          {
            "tag": "b",
            "content": "SEL"
          }
        ]
      },
      {
        "fieldTag": "y",
        "marcTag": "944",
        "ind1": " ",
        "ind2": " ",
        "content": nil,
        "subfields": [
          {
            "tag": "a",
            "content": "9781896580601 9781896580602 9781896580603 9781896580604 9781896580605 9781896580606 9781896580607 9781896580608 9781896580609 9781896580610"
          }
        ]
      },
      {
        "fieldTag": "_",
        "marcTag": nil,
        "ind1": nil,
        "ind2": nil,
        "content": "00000nam  2200000 a 4500",
        "subfields": nil
      }
    ]
  },
  {
    "id": "#{BNUMBER2}",
    "nyplSource": "sierra-nypl",
    "nyplType": "bib",
    "updatedDate": "2017-08-23T20:22:13-04:00",
    "createdDate": "2017-08-23T14:46:46-04:00",
    "deletedDate": nil,
    "deleted": false,
    "locations": [
      {
        "code": "ed",
        "name": "LSC Educator Collection"
      }
    ],
    "suppressed": false,
    "lang": {
      "code": "eng",
      "name": "English"
    },
    "title": "Title 2",
    "author": "",
    "materialType": {
      "code": "8",
      "value": "TEACHER SET"
    },
    "bibLevel": {
      "code": "m",
      "value": "MONOGRAPH"
    },
    "publishYear": nil,
    "catalogDate": "2017-08-23",
    "country": {
      "code": "xx ",
      "name": "Unknown or undetermined"
    },
    "normTitle": "books for reading and sharing elementary school",
    "normAuthor": "",
    "standardNumbers": [],
    "controlNumber": "",
    "fixedFields": {
      "24": {
        "label": "Language",
        "value": "eng",
        "display": "English"
      },
      "25": {
        "label": "Skip",
        "value": "0",
        "display": nil
      },
      "26": {
        "label": "Location",
        "value": "ed   ",
        "display": "LSC Educator Collection"
      },
      "27": {
        "label": "COPIES",
        "value": "0",
        "display": nil
      },
      "28": {
        "label": "Cat. Date",
        "value": "2017-08-23",
        "display": nil
      },
      "29": {
        "label": "Bib Level",
        "value": "m",
        "display": "MONOGRAPH"
      },
      "30": {
        "label": "Material Type",
        "value": "8",
        "display": "TEACHER SET"
      },
      "31": {
        "label": "Bib Code 3",
        "value": "-",
        "display": nil
      },
      "80": {
        "label": "Record Type",
        "value": "b",
        "display": nil
      },
      "81": {
        "label": "Record Number",
        "value": "21323534",
        "display": nil
      },
      "83": {
        "label": "Created Date",
        "value": "2017-08-23T14:46:46Z",
        "display": nil
      },
      "84": {
        "label": "Updated Date",
        "value": "2017-08-23T20:22:13Z",
        "display": nil
      },
      "85": {
        "label": "No. of Revisions",
        "value": "2",
        "display": nil
      },
      "86": {
        "label": "Agency",
        "value": "1",
        "display": nil
      },
      "89": {
        "label": "Country",
        "value": "xx ",
        "display": "Unknown or undetermined"
      },
      "98": {
        "label": "PDATE",
        "value": "2017-08-23T20:20:00Z",
        "display": nil
      },
      "107": {
        "label": "MARC Type",
        "value": " ",
        "display": nil
      }
    },
    "varFields": [
      {
        "fieldTag": "c",
        "marcTag": "091",
        "ind1": " ",
        "ind2": " ",
        "content": nil,
        "subfields": [
          {
            "tag": "a",
            "content": "Teacher Set ELA A Books 4"
          }
        ]
      },
      {
        "fieldTag": "d",
        "marcTag": "650",
        "ind1": " ",
        "ind2": "1",
        "content": nil,
        "subfields": [
          {
            "tag": "a",
            "content": "Political activists."
          }
        ]
      },
      {
        "fieldTag": "d",
        "marcTag": "650",
        "ind1": " ",
        "ind2": "1",
        "content": nil,
        "subfields": [
          {
            "tag": "a",
            "content": "Race relations."
          }
        ]
      },
      {
        "fieldTag": "d",
        "marcTag": "690",
        "ind1": "0",
        "ind2": "7",
        "content": nil,
        "subfields": [
          {
            "tag": "a",
            "content": "English Language Arts."
          },
          {
            "tag": "2",
            "content": "local"
          }
        ]
      },
      {
        "fieldTag": "n",
        "marcTag": "500",
        "ind1": " ",
        "ind2": " ",
        "content": nil,
        "subfields": [
          {
            "tag": "a",
            "content": "2 copies of 10 titles."
          }
        ]
      },
      {
        "fieldTag": "n",
        "marcTag": "505",
        "ind1": " ",
        "ind2": " ",
        "content": nil,
        "subfields": [
          {
            "tag": "a",
            "content": "Anna carries water -- Monkey & Robot -- Mother Bruce -- The book with no pictures -- The day the crayons quit -- The scraps book : notes from a colorful life -- Three bears in a boat -- Blizzard -- Bright Sky, Starry City -- Hula-Hoopin Queen."
          }
        ]
      },
      {
        "fieldTag": "n",
        "marcTag": "520",
        "ind1": " ",
        "ind2": " ",
        "content": nil,
        "subfields": [
          {
            "tag": "a",
            "content": "Topic Set (20 books) - This set of titles are great for reading aloud and sharing in the classroom - grades 1 and grades 2.  These titles were former selections from the NYC Department of Education NYC Reads 365 list."
          }
        ]
      },
      {
        "fieldTag": "e",
        "marcTag": "250",
        "ind1": " ",
        "ind2": " ",
        "content": nil,
        "subfields": [
          {
            "tag": "a",
            "content": "1st Hyperion Paperbacks ed."
          }
        ]
      },
      {
        "fieldTag": "i",
        "marcTag": "020",
        "ind1": " ",
        "ind2": " ",
        "content": nil,
        "subfields": [
          {
            "tag": "a",
            "content": "9781489813930"
          }
        ]
      },
      {
        "fieldTag": "p",
        "marcTag": "260",
        "ind1": " ",
        "ind2": " ",
        "content": nil,
        "subfields": [
          {
            "tag": "a",
            "content": "McHenry, Ill. :"
          },
          {
            "tag": "b",
            "content": "Follett Library Resources,"
          },
          {
            "tag": "c",
            "content": "2013."
          }
        ]
      },
      {
        "fieldTag": "n",
        "marcTag": "521",
        "ind1": "2",
        "ind2": " ",
        "content": nil,
        "subfields": [
          {
            "tag": "a",
            "content": "K-1."
          }
        ]
      },
      {
        "fieldTag": "n",
        "marcTag": "521",
        "ind1": "2",
        "ind2": " ",
        "content": nil,
        "subfields": [
          {
            "tag": "a",
            "content": "1-2."
          }
        ]
      },
      {
        "fieldTag": "n",
        "marcTag": "521",
        "ind1": "8",
        "ind2": " ",
        "content": nil,
        "subfields": [
          {
            "tag": "a",
            "content": "70L-500L"
          },
          {
            "tag": "b",
            "content": "Lexile"
          }
        ]
      },
      {
        "fieldTag": "r",
        "marcTag": "300",
        "ind1": " ",
        "ind2": " ",
        "content": nil,
        "subfields": [
          {
            "tag": "a",
            "content": "20 v."
          }
        ]
      },
      {
        "fieldTag": "s",
        "marcTag": "490",
        "ind1": "0",
        "ind2": " ",
        "content": nil,
        "subfields": [
          {
            "tag": "a",
            "content": "Teacher Sets: MyLibraryNYC Program"
          }
        ]
      },
      {
        "fieldTag": "t",
        "marcTag": "245",
        "ind1": "0",
        "ind2": "0",
        "content": nil,
        "subfields": [
          {
            "tag": "a",
            "content": "Books for Reading and Sharing - Elementary School! 3"
          }
        ]
      },
      {
        "fieldTag": "u",
        "marcTag": "246",
        "ind1": "3",
        "ind2": "0",
        "content": nil,
        "subfields": [
          {
            "tag": "a",
            "content": "English Language Arts: Books for Reading and Sharing - Elementary School! Gr. 1-2 (Teacher Set)."
          }
        ]
      },
      {
        "fieldTag": "y",
        "marcTag": "901",
        "ind1": " ",
        "ind2": " ",
        "content": nil,
        "subfields": [
          {
            "tag": "a",
            "content": "ed"
          },
          {
            "tag": "b",
            "content": "SEL"
          }
        ]
      },
      {
        "fieldTag": "y",
        "marcTag": "944",
        "ind1": " ",
        "ind2": " ",
        "content": nil,
        "subfields": [
          {
            "tag": "a",
            "content": "9781896580611 9781896580612 9781896580613 9781896580614 9781896580615 9781896580616 9781896580617 9781896580618 9781896580619 9781896580620"
          }
        ]
      },
      {
        "fieldTag": "_",
        "marcTag": nil,
        "ind1": nil,
        "ind2": nil,
        "content": "00000nam  2200000 a 4500",
        "subfields": nil
      }
    ]
  }
]

ONE_TEACHER_SET_WITH_A_BOOK_ISBN_OF_300_CHARACTERS = [
  {
    "id": "#{BNUMBER1}",
    "nyplSource": "sierra-nypl",
    "nyplType": "bib",
    "updatedDate": "2017-08-23T20:22:13-04:00",
    "createdDate": "2017-08-23T14:46:46-04:00",
    "deletedDate": nil,
    "deleted": false,
    "locations": [
      {
        "code": "ed",
        "name": "LSC Educator Collection"
      }
    ],
    "suppressed": false,
    "lang": {
      "code": "eng",
      "name": "English"
    },
    "title": "Books for Reading and Sharing - Elementary School! 1",
    "author": "",
    "materialType": {
      "code": "8",
      "value": "TEACHER SET"
    },
    "bibLevel": {
      "code": "m",
      "value": "MONOGRAPH"
    },
    "publishYear": nil,
    "catalogDate": "2017-08-23",
    "country": {
      "code": "xx ",
      "name": "Unknown or undetermined"
    },
    "normTitle": "books for reading and sharing elementary school",
    "normAuthor": "",
    "standardNumbers": [],
    "controlNumber": "",
    "fixedFields": {
      "24": {
        "label": "Language",
        "value": "eng",
        "display": "English"
      },
      "25": {
        "label": "Skip",
        "value": "0",
        "display": nil
      },
      "26": {
        "label": "Location",
        "value": "ed   ",
        "display": "LSC Educator Collection"
      },
      "27": {
        "label": "COPIES",
        "value": "0",
        "display": nil
      },
      "28": {
        "label": "Cat. Date",
        "value": "2017-08-23",
        "display": nil
      },
      "29": {
        "label": "Bib Level",
        "value": "m",
        "display": "MONOGRAPH"
      },
      "30": {
        "label": "Material Type",
        "value": "8",
        "display": "TEACHER SET"
      },
      "31": {
        "label": "Bib Code 3",
        "value": "-",
        "display": nil
      },
      "80": {
        "label": "Record Type",
        "value": "b",
        "display": nil
      },
      "81": {
        "label": "Record Number",
        "value": "21323534",
        "display": nil
      },
      "83": {
        "label": "Created Date",
        "value": "2017-08-23T14:46:46Z",
        "display": nil
      },
      "84": {
        "label": "Updated Date",
        "value": "2017-08-23T20:22:13Z",
        "display": nil
      },
      "85": {
        "label": "No. of Revisions",
        "value": "2",
        "display": nil
      },
      "86": {
        "label": "Agency",
        "value": "1",
        "display": nil
      },
      "89": {
        "label": "Country",
        "value": "xx ",
        "display": "Unknown or undetermined"
      },
      "98": {
        "label": "PDATE",
        "value": "2017-08-23T20:20:00Z",
        "display": nil
      },
      "107": {
        "label": "MARC Type",
        "value": " ",
        "display": nil
      }
    },
    "varFields": [
      {
        "fieldTag": "c",
        "marcTag": "091",
        "ind1": " ",
        "ind2": " ",
        "content": nil,
        "subfields": [
          {
            "tag": "a",
            "content": "Teacher Set ELA A Books 4"
          }
        ]
      },
      {
        "fieldTag": "d",
        "marcTag": "650",
        "ind1": " ",
        "ind2": "1",
        "content": nil,
        "subfields": [
          {
            "tag": "a",
            "content": "Political activists."
          }
        ]
      },
      {
        "fieldTag": "d",
        "marcTag": "650",
        "ind1": " ",
        "ind2": "1",
        "content": nil,
        "subfields": [
          {
            "tag": "a",
            "content": "Race relations."
          }
        ]
      },
      {
        "fieldTag": "d",
        "marcTag": "690",
        "ind1": "0",
        "ind2": "7",
        "content": nil,
        "subfields": [
          {
            "tag": "a",
            "content": "English Language Arts."
          },
          {
            "tag": "2",
            "content": "local"
          }
        ]
      },
      {
        "fieldTag": "n",
        "marcTag": "500",
        "ind1": " ",
        "ind2": " ",
        "content": nil,
        "subfields": [
          {
            "tag": "a",
            "content": "2 copies of 10 titles."
          }
        ]
      },
      {
        "fieldTag": "n",
        "marcTag": "505",
        "ind1": " ",
        "ind2": " ",
        "content": nil,
        "subfields": [
          {
            "tag": "a",
            "content": "Anna carries water -- Monkey & Robot -- Mother Bruce -- The book with no pictures -- The day the crayons quit -- The scraps book : notes from a colorful life -- Three bears in a boat -- Blizzard -- Bright Sky, Starry City -- Hula-Hoopin Queen."
          }
        ]
      },
      {
        "fieldTag": "n",
        "marcTag": "520",
        "ind1": " ",
        "ind2": " ",
        "content": nil,
        "subfields": [
          {
            "tag": "a",
            "content": "Topic Set (20 books) - This set of titles are great for reading aloud and sharing in the classroom - grades 1 and grades 2.  These titles were former selections from the NYC Department of Education NYC Reads 365 list."
          }
        ]
      },
      {
        "fieldTag": "e",
        "marcTag": "250",
        "ind1": " ",
        "ind2": " ",
        "content": nil,
        "subfields": [
          {
            "tag": "a",
            "content": "1st Hyperion Paperbacks ed."
          }
        ]
      },
      {
        "fieldTag": "i",
        "marcTag": "020",
        "ind1": " ",
        "ind2": " ",
        "content": nil,
        "subfields": [
          {
            "tag": "a",
            "content": "9781489813930"
          }
        ]
      },
      {
        "fieldTag": "p",
        "marcTag": "260",
        "ind1": " ",
        "ind2": " ",
        "content": nil,
        "subfields": [
          {
            "tag": "a",
            "content": "McHenry, Ill. :"
          },
          {
            "tag": "b",
            "content": "Follett Library Resources,"
          },
          {
            "tag": "c",
            "content": "2013."
          }
        ]
      },
      {
        "fieldTag": "n",
        "marcTag": "521",
        "ind1": "2",
        "ind2": " ",
        "content": nil,
        "subfields": [
          {
            "tag": "a",
            "content": "K-1."
          }
        ]
      },
      {
        "fieldTag": "n",
        "marcTag": "521",
        "ind1": "2",
        "ind2": " ",
        "content": nil,
        "subfields": [
          {
            "tag": "a",
            "content": "1-2."
          }
        ]
      },
      {
        "fieldTag": "n",
        "marcTag": "521",
        "ind1": "8",
        "ind2": " ",
        "content": nil,
        "subfields": [
          {
            "tag": "a",
            "content": "70L-500L"
          },
          {
            "tag": "b",
            "content": "Lexile"
          }
        ]
      },
      {
        "fieldTag": "r",
        "marcTag": "300",
        "ind1": " ",
        "ind2": " ",
        "content": nil,
        "subfields": [
          {
            "tag": "a",
            "content": "20 v."
          }
        ]
      },
      {
        "fieldTag": "s",
        "marcTag": "490",
        "ind1": "0",
        "ind2": " ",
        "content": nil,
        "subfields": [
          {
            "tag": "a",
            "content": "Teacher Sets: MyLibraryNYC Program"
          }
        ]
      },
      {
        "fieldTag": "t",
        "marcTag": "245",
        "ind1": "0",
        "ind2": "0",
        "content": nil,
        "subfields": [
          {
            "tag": "a",
            "content": "Books for Reading and Sharing - Elementary School! 2"
          }
        ]
      },
      {
        "fieldTag": "u",
        "marcTag": "246",
        "ind1": "3",
        "ind2": "0",
        "content": nil,
        "subfields": [
          {
            "tag": "a",
            "content": "English Language Arts: Books for Reading and Sharing - Elementary School! Gr. 1-2 (Teacher Set)."
          }
        ]
      },
      {
        "fieldTag": "y",
        "marcTag": "901",
        "ind1": " ",
        "ind2": " ",
        "content": nil,
        "subfields": [
          {
            "tag": "a",
            "content": "ed"
          },
          {
            "tag": "b",
            "content": "SEL"
          }
        ]
      },
      {
        "fieldTag": "y",
        "marcTag": "944",
        "ind1": " ",
        "ind2": " ",
        "content": nil,
        "subfields": [
          {
            "tag": "a",
            "content": "123456789"
          }
        ]
      },
      {
        "fieldTag": "_",
        "marcTag": nil,
        "ind1": nil,
        "ind2": nil,
        "content": "00000nam  2200000 a 4500",
        "subfields": nil
      }
    ]
  }
]

# This is the book for this teacher set: ONE_TEACHER_SET_WITH_A_BOOK_ISBN_OF_300_CHARACTERS
JSON_FOR_BOOK_WITH_ISBN_AND_TITLE_TOO_LONG = '{
  "data": [
    {
      "id": "18888888",
      "nyplSource": "sierra-nypl",
      "nyplType": "bib",
      "updatedDate": "2016-02-15T03:03:46-05:00",
      "createdDate": "2011-03-31T14:07:37-04:00",
      "deletedDate": null,
      "deleted": false,
      "locations": [
        {
          "code": "bca",
          "name": "Bronx Library Center Adult"
        }
      ],
      "suppressed": false,
      "lang": {
        "code": "fre",
        "name": "French"
      },
      "title": "Title is intentionally > 255 characters 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 ",
      "author": "Arrighi, Olivier.",
      "materialType": {
        "code": "a",
        "value": "BOOK/TEXT"
      },
      "bibLevel": {
        "code": "m",
        "value": "MONOGRAPH"
      },
      "publishYear": 2010,
      "catalogDate": "2011-03-31",
      "country": {
        "code": "fr ",
        "name": "France"
      },
      "normTitle": "pasé on bel nwel lieutenant simeoni roman policier",
      "normAuthor": "arrighi olivier",
      "standardNumbers": [
        "This ISBN intentionally > 255 characters 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 ",
        "2917623268"
      ],
      "controlNumber": "696084229",
      "fixedFields": {
        "24": {
          "label": "Language",
          "value": "fre",
          "display": "French"
        },
        "25": {
          "label": "Skip",
          "value": "0",
          "display": null
        },
        "26": {
          "label": "Location",
          "value": "bca  ",
          "display": "Bronx Library Center Adult"
        },
        "27": {
          "label": "COPIES",
          "value": "2",
          "display": null
        },
        "28": {
          "label": "Cat. Date",
          "value": "2011-03-31",
          "display": null
        },
        "29": {
          "label": "Bib Level",
          "value": "m",
          "display": "MONOGRAPH"
        },
        "30": {
          "label": "Material Type",
          "value": "a",
          "display": "BOOK/TEXT"
        },
        "31": {
          "label": "Bib Code 3",
          "value": "-",
          "display": null
        },
        "80": {
          "label": "Record Type",
          "value": "b",
          "display": null
        },
        "81": {
          "label": "Record Number",
          "value": "18888888",
          "display": null
        },
        "83": {
          "label": "Created Date",
          "value": "2011-03-31T14:07:37Z",
          "display": null
        },
        "84": {
          "label": "Updated Date",
          "value": "2016-02-15T03:03:46Z",
          "display": null
        },
        "85": {
          "label": "No. of Revisions",
          "value": "6",
          "display": null
        },
        "86": {
          "label": "Agency",
          "value": "1",
          "display": null
        },
        "89": {
          "label": "Country",
          "value": "fr ",
          "display": "France"
        },
        "98": {
          "label": "PDATE",
          "value": "2016-02-14T06:26:14Z",
          "display": null
        },
        "107": {
          "label": "MARC Type",
          "value": " ",
          "display": null
        }
      },
      "varFields": [
        {
          "fieldTag": "n",
          "marcTag": "520",
          "ind1": " ",
          "ind2": " ",
          "content": null,
          "subfields": [
            {
              "tag": "a",
              "content": "Despite the medical miracle that has bought her a few more years, Hazel has never been anything but terminal, but when Augustus Waters suddenly appears at the Cancer Kid Support Group, Hazels story is about to be rewritten."
            }
          ]
        },
        {
          "fieldTag": "a",
          "marcTag": "100",
          "ind1": "1",
          "ind2": " ",
          "content": null,
          "subfields": [
            {
              "tag": "a",
              "content": "Arrighi, Olivier."
            }
          ]
        },
        {
          "fieldTag": "c",
          "marcTag": "091",
          "ind1": " ",
          "ind2": " ",
          "content": null,
          "subfields": [
            {
              "tag": "p",
              "content": "Fre"
            },
            {
              "tag": "a",
              "content": "FIC"
            },
            {
              "tag": "c",
              "content": "A"
            }
          ]
        },
        {
          "fieldTag": "i",
          "marcTag": "020",
          "ind1": " ",
          "ind2": " ",
          "content": null,
          "subfields": [
            {
              "tag": "a",
              "content": "9782917623268 (pbk.)"
            }
          ]
        },
        {
          "fieldTag": "i",
          "marcTag": "020",
          "ind1": " ",
          "ind2": " ",
          "content": null,
          "subfields": [
            {
              "tag": "a",
              "content": "2917623268 (pbk.)"
            }
          ]
        },
        {
          "fieldTag": "l",
          "marcTag": "035",
          "ind1": " ",
          "ind2": " ",
          "content": null,
          "subfields": [
            {
              "tag": "a",
              "content": "(OCoLC)696084229"
            }
          ]
        },
        {
          "fieldTag": "o",
          "marcTag": "001",
          "ind1": " ",
          "ind2": " ",
          "content": "696084229",
          "subfields": null
        },
        {
          "fieldTag": "p",
          "marcTag": "260",
          "ind1": " ",
          "ind2": " ",
          "content": null,
          "subfields": [
            {
              "tag": "a",
              "content": "Lamentin :"
            },
            {
              "tag": "b",
              "content": "Caraïbéditions,"
            },
            {
              "tag": "c",
              "content": "c2010."
            }
          ]
        },
        {
          "fieldTag": "r",
          "marcTag": "300",
          "ind1": " ",
          "ind2": " ",
          "content": null,
          "subfields": [
            {
              "tag": "a",
              "content": "236 p. ;"
            },
            {
              "tag": "c",
              "content": "22 cm."
            }
          ]
        },
        {
          "fieldTag": "s",
          "marcTag": "490",
          "ind1": "0",
          "ind2": " ",
          "content": null,
          "subfields": [
            {
              "tag": "a",
              "content": "Polar"
            }
          ]
        },
        {
          "fieldTag": "t",
          "marcTag": "245",
          "ind1": "1",
          "ind2": "0",
          "content": null,
          "subfields": [
            {
              "tag": "a",
              "content": "Pasé on bel Nwel lieutenant Simeoni! :"
            },
            {
              "tag": "b",
              "content": "roman policier /"
            },
            {
              "tag": "c",
              "content": "Olivier Arrighi."
            }
          ]
        },
        {
          "fieldTag": "y",
          "marcTag": "003",
          "ind1": " ",
          "ind2": " ",
          "content": "OCoLC",
          "subfields": null
        },
        {
          "fieldTag": "y",
          "marcTag": "005",
          "ind1": " ",
          "ind2": " ",
          "content": "20110330110134.0",
          "subfields": null
        },
        {
          "fieldTag": "y",
          "marcTag": "008",
          "ind1": " ",
          "ind2": " ",
          "content": "101229s2010    fr     g      000 1 fre dnamIa ",
          "subfields": null
        },
        {
          "fieldTag": "y",
          "marcTag": "040",
          "ind1": " ",
          "ind2": " ",
          "content": null,
          "subfields": [
            {
              "tag": "a",
              "content": "AUXAM"
            },
            {
              "tag": "c",
              "content": "AUXAM"
            },
            {
              "tag": "d",
              "content": "NYP"
            }
          ]
        },
        {
          "fieldTag": "y",
          "marcTag": "049",
          "ind1": " ",
          "ind2": " ",
          "content": null,
          "subfields": [
            {
              "tag": "a",
              "content": "NYPP"
            }
          ]
        },
        {
          "fieldTag": "y",
          "marcTag": "901",
          "ind1": " ",
          "ind2": " ",
          "content": null,
          "subfields": [
            {
              "tag": "a",
              "content": "rbf"
            },
            {
              "tag": "b",
              "content": "CMC"
            },
            {
              "tag": "c",
              "content": "CATBL"
            }
          ]
        },
        {
          "fieldTag": "y",
          "marcTag": "901",
          "ind1": " ",
          "ind2": " ",
          "content": null,
          "subfields": [
            {
              "tag": "a",
              "content": "MARS"
            }
          ]
        },
        {
          "fieldTag": "y",
          "marcTag": "946",
          "ind1": " ",
          "ind2": " ",
          "content": null,
          "subfields": [
            {
              "tag": "a",
              "content": "m"
            }
          ]
        },
        {
          "fieldTag": "y",
          "marcTag": "949",
          "ind1": " ",
          "ind2": "1",
          "content": null,
          "subfields": [
            {
              "tag": "l",
              "content": "wfa0l"
            },
            {
              "tag": "i",
              "content": "33333804031256"
            },
            {
              "tag": "t",
              "content": "102"
            },
            {
              "tag": "s",
              "content": "b"
            },
            {
              "tag": "p",
              "content": "$10.00"
            },
            {
              "tag": "v",
              "content": "CATBL/CMC/rbf"
            }
          ]
        },
        {
          "fieldTag": "y",
          "marcTag": "949",
          "ind1": " ",
          "ind2": "1",
          "content": null,
          "subfields": [
            {
              "tag": "l",
              "content": "bca0l"
            },
            {
              "tag": "i",
              "content": "33333804031249"
            },
            {
              "tag": "t",
              "content": "102"
            },
            {
              "tag": "s",
              "content": "b"
            },
            {
              "tag": "p",
              "content": "$10.00"
            },
            {
              "tag": "v",
              "content": "CATBL/CMC/rbf"
            }
          ]
        },
        {
          "fieldTag": "_",
          "marcTag": null,
          "ind1": null,
          "ind2": null,
          "content": "00000nam  2200301Ia 4500",
          "subfields": null
        }
      ]
    }
  ],
  "count": 1,
  "totalCount": 0,
  "statusCode": 200,
  "debugInfo": []
}'

TWO_TEACHER_SETS_WITH_3_ISBNS_EACH = [
  {
    "id": "#{BNUMBER1}",
    "nyplSource": "sierra-nypl",
    "nyplType": "bib",
    "updatedDate": "2017-08-23T20:22:13-04:00",
    "createdDate": "2017-08-23T14:46:46-04:00",
    "deletedDate": nil,
    "deleted": false,
    "locations": [
      {
        "code": "ed",
        "name": "LSC Educator Collection"
      }
    ],
    "suppressed": false,
    "lang": {
      "code": "eng",
      "name": "English"
    },
    "title": "Books for Reading and Sharing - Elementary School! 4",
    "author": "",
    "materialType": {
      "code": "8",
      "value": "TEACHER SET"
    },
    "bibLevel": {
      "code": "m",
      "value": "MONOGRAPH"
    },
    "publishYear": nil,
    "catalogDate": "2017-08-23",
    "country": {
      "code": "xx ",
      "name": "Unknown or undetermined"
    },
    "normTitle": "books for reading and sharing elementary school",
    "normAuthor": "",
    "standardNumbers": [],
    "controlNumber": "",
    "fixedFields": {
      "24": {
        "label": "Language",
        "value": "eng",
        "display": "English"
      },
      "25": {
        "label": "Skip",
        "value": "0",
        "display": nil
      },
      "26": {
        "label": "Location",
        "value": "ed   ",
        "display": "LSC Educator Collection"
      },
      "27": {
        "label": "COPIES",
        "value": "0",
        "display": nil
      },
      "28": {
        "label": "Cat. Date",
        "value": "2017-08-23",
        "display": nil
      },
      "29": {
        "label": "Bib Level",
        "value": "m",
        "display": "MONOGRAPH"
      },
      "30": {
        "label": "Material Type",
        "value": "8",
        "display": "TEACHER SET"
      },
      "31": {
        "label": "Bib Code 3",
        "value": "-",
        "display": nil
      },
      "80": {
        "label": "Record Type",
        "value": "b",
        "display": nil
      },
      "81": {
        "label": "Record Number",
        "value": "21323534",
        "display": nil
      },
      "83": {
        "label": "Created Date",
        "value": "2017-08-23T14:46:46Z",
        "display": nil
      },
      "84": {
        "label": "Updated Date",
        "value": "2017-08-23T20:22:13Z",
        "display": nil
      },
      "85": {
        "label": "No. of Revisions",
        "value": "2",
        "display": nil
      },
      "86": {
        "label": "Agency",
        "value": "1",
        "display": nil
      },
      "89": {
        "label": "Country",
        "value": "xx ",
        "display": "Unknown or undetermined"
      },
      "98": {
        "label": "PDATE",
        "value": "2017-08-23T20:20:00Z",
        "display": nil
      },
      "107": {
        "label": "MARC Type",
        "value": " ",
        "display": nil
      }
    },
    "varFields": [
      {
        "fieldTag": "d",
        "marcTag": "655",
        "ind1": " ",
        "ind2": "7",
        "content": nil,
        "subfields": [
          {
            "tag": "a",
            "content": "Stories in rhyme."
          },
          {
            "tag": "2",
            "content": "lcgft"
          }
        ]
      },
      {
        "fieldTag": "c",
        "marcTag": "091",
        "ind1": " ",
        "ind2": " ",
        "content": nil,
        "subfields": [
          {
            "tag": "a",
            "content": "Teacher Set ELA A Books 4"
          }
        ]
      },
      {
        "fieldTag": "d",
        "marcTag": "650",
        "ind1": " ",
        "ind2": "1",
        "content": nil,
        "subfields": [
          {
            "tag": "a",
            "content": "Political activists."
          }
        ]
      },
      {
        "fieldTag": "d",
        "marcTag": "650",
        "ind1": " ",
        "ind2": "1",
        "content": nil,
        "subfields": [
          {
            "tag": "a",
            "content": "Race relations."
          }
        ]
      },
      {
        "fieldTag": "d",
        "marcTag": "690",
        "ind1": "0",
        "ind2": "7",
        "content": nil,
        "subfields": [
          {
            "tag": "a",
            "content": "English Language Arts."
          },
          {
            "tag": "2",
            "content": "local"
          }
        ]
      },
      {
        "fieldTag": "n",
        "marcTag": "500",
        "ind1": " ",
        "ind2": " ",
        "content": nil,
        "subfields": [
          {
            "tag": "a",
            "content": "2 copies of 10 titles."
          }
        ]
      },
      {
        "fieldTag": "n",
        "marcTag": "505",
        "ind1": " ",
        "ind2": " ",
        "content": nil,
        "subfields": [
          {
            "tag": "a",
            "content": "Anna carries water -- Monkey & Robot -- Mother Bruce -- The book with no pictures -- The day the crayons quit -- The scraps book : notes from a colorful life -- Three bears in a boat -- Blizzard -- Bright Sky, Starry City -- Hula-Hoopin Queen."
          }
        ]
      },
      {
        "fieldTag": "n",
        "marcTag": "520",
        "ind1": " ",
        "ind2": " ",
        "content": nil,
        "subfields": [
          {
            "tag": "a",
            "content": "Topic Set (20 books) - This set of titles are great for reading aloud and sharing in the classroom - grades 1 and grades 2.  These titles were former selections from the NYC Department of Education NYC Reads 365 list."
          }
        ]
      },
      {
        "fieldTag": "e",
        "marcTag": "250",
        "ind1": " ",
        "ind2": " ",
        "content": nil,
        "subfields": [
          {
            "tag": "a",
            "content": "1st Hyperion Paperbacks ed."
          }
        ]
      },
      {
        "fieldTag": "i",
        "marcTag": "020",
        "ind1": " ",
        "ind2": " ",
        "content": nil,
        "subfields": [
          {
            "tag": "a",
            "content": "9781489813930"
          }
        ]
      },
      {
        "fieldTag": "p",
        "marcTag": "260",
        "ind1": " ",
        "ind2": " ",
        "content": nil,
        "subfields": [
          {
            "tag": "a",
            "content": "McHenry, Ill. :"
          },
          {
            "tag": "b",
            "content": "Follett Library Resources,"
          },
          {
            "tag": "c",
            "content": "2013."
          }
        ]
      },
      {
        "fieldTag": "n",
        "marcTag": "521",
        "ind1": "2",
        "ind2": " ",
        "content": nil,
        "subfields": [
          {
            "tag": "a",
            "content": "K-1."
          }
        ]
      },
      {
        "fieldTag": "n",
        "marcTag": "521",
        "ind1": "2",
        "ind2": " ",
        "content": nil,
        "subfields": [
          {
            "tag": "a",
            "content": "1-2."
          }
        ]
      },
      {
        "fieldTag": "n",
        "marcTag": "521",
        "ind1": "8",
        "ind2": " ",
        "content": nil,
        "subfields": [
          {
            "tag": "a",
            "content": "70L-500L"
          },
          {
            "tag": "b",
            "content": "Lexile"
          }
        ]
      },
      {
        "fieldTag": "r",
        "marcTag": "300",
        "ind1": " ",
        "ind2": " ",
        "content": nil,
        "subfields": [
          {
            "tag": "a",
            "content": "20 v."
          }
        ]
      },
      {
        "fieldTag": "s",
        "marcTag": "490",
        "ind1": "0",
        "ind2": " ",
        "content": nil,
        "subfields": [
          {
            "tag": "a",
            "content": "Teacher Sets: MyLibraryNYC Program"
          }
        ]
      },
      {
        "fieldTag": "t",
        "marcTag": "245",
        "ind1": "0",
        "ind2": "0",
        "content": nil,
        "subfields": [
          {
            "tag": "a",
            "content": "Books for Reading and Sharing - Elementary School! 5"
          }
        ]
      },
      {
        "fieldTag": "u",
        "marcTag": "246",
        "ind1": "3",
        "ind2": "0",
        "content": nil,
        "subfields": [
          {
            "tag": "a",
            "content": "English Language Arts: Books for Reading and Sharing - Elementary School! Gr. 1-2 (Teacher Set)."
          }
        ]
      },
      {
        "fieldTag": "y",
        "marcTag": "901",
        "ind1": " ",
        "ind2": " ",
        "content": nil,
        "subfields": [
          {
            "tag": "a",
            "content": "ed"
          },
          {
            "tag": "b",
            "content": "SEL"
          }
        ]
      },
      {
        "fieldTag": "y",
        "marcTag": "944",
        "ind1": " ",
        "ind2": " ",
        "content": nil,
        "subfields": [
          {
            "tag": "a",
            "content": "9781896580601 9781896580602 9781896580603"
          }
        ]
      },
      {
        "fieldTag": "_",
        "marcTag": nil,
        "ind1": nil,
        "ind2": nil,
        "content": "00000nam  2200000 a 4500",
        "subfields": nil
      }
    ]
  },
  {
    "id": "#{BNUMBER2}",
    "nyplSource": "sierra-nypl",
    "nyplType": "bib",
    "updatedDate": "2017-08-23T20:22:13-04:00",
    "createdDate": "2017-08-23T14:46:46-04:00",
    "deletedDate": nil,
    "deleted": false,
    "locations": [
      {
        "code": "ed",
        "name": "LSC Educator Collection"
      }
    ],
    "suppressed": false,
    "lang": {
      "code": "eng",
      "name": "English"
    },
    "title": "Title 2",
    "author": "",
    "materialType": {
      "code": "8",
      "value": "TEACHER SET"
    },
    "bibLevel": {
      "code": "m",
      "value": "MONOGRAPH"
    },
    "publishYear": nil,
    "catalogDate": "2017-08-23",
    "country": {
      "code": "xx ",
      "name": "Unknown or undetermined"
    },
    "normTitle": "books for reading and sharing elementary school",
    "normAuthor": "",
    "standardNumbers": [],
    "controlNumber": "",
    "fixedFields": {
      "24": {
        "label": "Language",
        "value": "eng",
        "display": "English"
      },
      "25": {
        "label": "Skip",
        "value": "0",
        "display": nil
      },
      "26": {
        "label": "Location",
        "value": "ed   ",
        "display": "LSC Educator Collection"
      },
      "27": {
        "label": "COPIES",
        "value": "0",
        "display": nil
      },
      "28": {
        "label": "Cat. Date",
        "value": "2017-08-23",
        "display": nil
      },
      "29": {
        "label": "Bib Level",
        "value": "m",
        "display": "MONOGRAPH"
      },
      "30": {
        "label": "Material Type",
        "value": "8",
        "display": "TEACHER SET"
      },
      "31": {
        "label": "Bib Code 3",
        "value": "-",
        "display": nil
      },
      "80": {
        "label": "Record Type",
        "value": "b",
        "display": nil
      },
      "81": {
        "label": "Record Number",
        "value": "21323534",
        "display": nil
      },
      "83": {
        "label": "Created Date",
        "value": "2017-08-23T14:46:46Z",
        "display": nil
      },
      "84": {
        "label": "Updated Date",
        "value": "2017-08-23T20:22:13Z",
        "display": nil
      },
      "85": {
        "label": "No. of Revisions",
        "value": "2",
        "display": nil
      },
      "86": {
        "label": "Agency",
        "value": "1",
        "display": nil
      },
      "89": {
        "label": "Country",
        "value": "xx ",
        "display": "Unknown or undetermined"
      },
      "98": {
        "label": "PDATE",
        "value": "2017-08-23T20:20:00Z",
        "display": nil
      },
      "107": {
        "label": "MARC Type",
        "value": " ",
        "display": nil
      }
    },
    "varFields": [
      {
        "fieldTag": "d",
        "marcTag": "655",
        "ind1": " ",
        "ind2": "7",
        "content": nil,
        "subfields": [
          {
            "tag": "a",
            "content": "Stories in rhyme."
          },
          {
            "tag": "2",
            "content": "lcgft"
          }
        ]
      },
      {
        "fieldTag": "c",
        "marcTag": "091",
        "ind1": " ",
        "ind2": " ",
        "content": nil,
        "subfields": [
          {
            "tag": "a",
            "content": "Teacher Set ELA A Books 4"
          }
        ]
      },
      {
        "fieldTag": "d",
        "marcTag": "650",
        "ind1": " ",
        "ind2": "1",
        "content": nil,
        "subfields": [
          {
            "tag": "a",
            "content": "Political activists."
          }
        ]
      },
      {
        "fieldTag": "d",
        "marcTag": "650",
        "ind1": " ",
        "ind2": "1",
        "content": nil,
        "subfields": [
          {
            "tag": "a",
            "content": "Race relations."
          }
        ]
      },
      {
        "fieldTag": "d",
        "marcTag": "690",
        "ind1": "0",
        "ind2": "7",
        "content": nil,
        "subfields": [
          {
            "tag": "a",
            "content": "English Language Arts."
          },
          {
            "tag": "2",
            "content": "local"
          }
        ]
      },
      {
        "fieldTag": "n",
        "marcTag": "500",
        "ind1": " ",
        "ind2": " ",
        "content": nil,
        "subfields": [
          {
            "tag": "a",
            "content": "2 copies of 10 titles."
          }
        ]
      },
      {
        "fieldTag": "n",
        "marcTag": "505",
        "ind1": " ",
        "ind2": " ",
        "content": nil,
        "subfields": [
          {
            "tag": "a",
            "content": "Anna carries water -- Monkey & Robot -- Mother Bruce -- The book with no pictures -- The day the crayons quit -- The scraps book : notes from a colorful life -- Three bears in a boat -- Blizzard -- Bright Sky, Starry City -- Hula-Hoopin Queen."
          }
        ]
      },
      {
        "fieldTag": "n",
        "marcTag": "520",
        "ind1": " ",
        "ind2": " ",
        "content": nil,
        "subfields": [
          {
            "tag": "a",
            "content": "Topic Set (20 books) - This set of titles are great for reading aloud and sharing in the classroom - grades 1 and grades 2.  These titles were former selections from the NYC Department of Education NYC Reads 365 list."
          }
        ]
      },
      {
        "fieldTag": "e",
        "marcTag": "250",
        "ind1": " ",
        "ind2": " ",
        "content": nil,
        "subfields": [
          {
            "tag": "a",
            "content": "1st Hyperion Paperbacks ed."
          }
        ]
      },
      {
        "fieldTag": "i",
        "marcTag": "020",
        "ind1": " ",
        "ind2": " ",
        "content": nil,
        "subfields": [
          {
            "tag": "a",
            "content": "9781489813930"
          }
        ]
      },
      {
        "fieldTag": "p",
        "marcTag": "260",
        "ind1": " ",
        "ind2": " ",
        "content": nil,
        "subfields": [
          {
            "tag": "a",
            "content": "McHenry, Ill. :"
          },
          {
            "tag": "b",
            "content": "Follett Library Resources,"
          },
          {
            "tag": "c",
            "content": "2013."
          }
        ]
      },
      {
        "fieldTag": "n",
        "marcTag": "521",
        "ind1": "2",
        "ind2": " ",
        "content": nil,
        "subfields": [
          {
            "tag": "a",
            "content": "K-1."
          }
        ]
      },
      {
        "fieldTag": "n",
        "marcTag": "521",
        "ind1": "2",
        "ind2": " ",
        "content": nil,
        "subfields": [
          {
            "tag": "a",
            "content": "1-2."
          }
        ]
      },
      {
        "fieldTag": "n",
        "marcTag": "521",
        "ind1": "8",
        "ind2": " ",
        "content": nil,
        "subfields": [
          {
            "tag": "a",
            "content": "70L-500L"
          },
          {
            "tag": "b",
            "content": "Lexile"
          }
        ]
      },
      {
        "fieldTag": "r",
        "marcTag": "300",
        "ind1": " ",
        "ind2": " ",
        "content": nil,
        "subfields": [
          {
            "tag": "a",
            "content": "20 v."
          }
        ]
      },
      {
        "fieldTag": "s",
        "marcTag": "490",
        "ind1": "0",
        "ind2": " ",
        "content": nil,
        "subfields": [
          {
            "tag": "a",
            "content": "Teacher Sets: MyLibraryNYC Program"
          }
        ]
      },
      {
        "fieldTag": "t",
        "marcTag": "245",
        "ind1": "0",
        "ind2": "0",
        "content": nil,
        "subfields": [
          {
            "tag": "a",
            "content": "Books for Reading and Sharing - Elementary School! 6"
          }
        ]
      },
      {
        "fieldTag": "u",
        "marcTag": "246",
        "ind1": "3",
        "ind2": "0",
        "content": nil,
        "subfields": [
          {
            "tag": "a",
            "content": "English Language Arts: Books for Reading and Sharing - Elementary School! Gr. 1-2 (Teacher Set)."
          }
        ]
      },
      {
        "fieldTag": "y",
        "marcTag": "901",
        "ind1": " ",
        "ind2": " ",
        "content": nil,
        "subfields": [
          {
            "tag": "a",
            "content": "ed"
          },
          {
            "tag": "b",
            "content": "SEL"
          }
        ]
      },
      {
        "fieldTag": "y",
        "marcTag": "944",
        "ind1": " ",
        "ind2": " ",
        "content": nil,
        "subfields": [
          {
            "tag": "a",
            "content": "9781896580611 9781896580612 9781896580613"
          }
        ]
      },
      {
        "fieldTag": "_",
        "marcTag": nil,
        "ind1": nil,
        "ind2": nil,
        "content": "00000nam  2200000 a 4500",
        "subfields": nil
      }
    ]
  }
]

TEACHER_SET_WITH_TITLE_MISSING = [
  {
    "id": "#{BNUMBER1}",
    "nyplSource": "sierra-nypl",
    "nyplType": "bib",
    "updatedDate": "2017-08-23T20:22:13-04:00",
    "createdDate": "2017-08-23T14:46:46-04:00",
    "deletedDate": nil,
    "deleted": false,
    "locations": [
      {
        "code": "ed",
        "name": "LSC Educator Collection"
      }
    ],
    "suppressed": false,
    "lang": {
      "code": "eng",
      "name": "English"
    },
    "title": nil,
    "author": "",
    "materialType": {
      "code": "8",
      "value": "TEACHER SET"
    },
    "bibLevel": {
      "code": "m",
      "value": "MONOGRAPH"
    },
    "publishYear": nil,
    "catalogDate": "2017-08-23",
    "country": {
      "code": "xx ",
      "name": "Unknown or undetermined"
    },
    "normTitle": "books for reading and sharing elementary school",
    "normAuthor": "",
    "standardNumbers": [],
    "controlNumber": "",
    "fixedFields": {
      "24": {
        "label": "Language",
        "value": "eng",
        "display": "English"
      },
      "25": {
        "label": "Skip",
        "value": "0",
        "display": nil
      },
      "26": {
        "label": "Location",
        "value": "ed   ",
        "display": "LSC Educator Collection"
      },
      "27": {
        "label": "COPIES",
        "value": "0",
        "display": nil
      },
      "28": {
        "label": "Cat. Date",
        "value": "2017-08-23",
        "display": nil
      },
      "29": {
        "label": "Bib Level",
        "value": "m",
        "display": "MONOGRAPH"
      },
      "30": {
        "label": "Material Type",
        "value": "8",
        "display": "TEACHER SET"
      },
      "31": {
        "label": "Bib Code 3",
        "value": "-",
        "display": nil
      },
      "80": {
        "label": "Record Type",
        "value": "b",
        "display": nil
      },
      "81": {
        "label": "Record Number",
        "value": "21323534",
        "display": nil
      },
      "83": {
        "label": "Created Date",
        "value": "2017-08-23T14:46:46Z",
        "display": nil
      },
      "84": {
        "label": "Updated Date",
        "value": "2017-08-23T20:22:13Z",
        "display": nil
      },
      "85": {
        "label": "No. of Revisions",
        "value": "2",
        "display": nil
      },
      "86": {
        "label": "Agency",
        "value": "1",
        "display": nil
      },
      "89": {
        "label": "Country",
        "value": "xx ",
        "display": "Unknown or undetermined"
      },
      "98": {
        "label": "PDATE",
        "value": "2017-08-23T20:20:00Z",
        "display": nil
      },
      "107": {
        "label": "MARC Type",
        "value": " ",
        "display": nil
      }
    },
    "varFields": [
      {
        "fieldTag": "c",
        "marcTag": "091",
        "ind1": " ",
        "ind2": " ",
        "content": nil,
        "subfields": [
          {
            "tag": "a",
            "content": "Teacher Set ELA A Books 4"
          }
        ]
      },
      {
        "fieldTag": "d",
        "marcTag": "650",
        "ind1": " ",
        "ind2": "1",
        "content": nil,
        "subfields": [
          {
            "tag": "a",
            "content": "Political activists."
          }
        ]
      },
      {
        "fieldTag": "d",
        "marcTag": "650",
        "ind1": " ",
        "ind2": "1",
        "content": nil,
        "subfields": [
          {
            "tag": "a",
            "content": "Race relations."
          }
        ]
      },
      {
        "fieldTag": "d",
        "marcTag": "690",
        "ind1": "0",
        "ind2": "7",
        "content": nil,
        "subfields": [
          {
            "tag": "a",
            "content": "English Language Arts."
          },
          {
            "tag": "2",
            "content": "local"
          }
        ]
      },
      {
        "fieldTag": "n",
        "marcTag": "500",
        "ind1": " ",
        "ind2": " ",
        "content": nil,
        "subfields": [
          {
            "tag": "a",
            "content": "2 copies of 10 titles."
          }
        ]
      },
      {
        "fieldTag": "n",
        "marcTag": "505",
        "ind1": " ",
        "ind2": " ",
        "content": nil,
        "subfields": [
          {
            "tag": "a",
            "content": "Anna carries water -- Monkey & Robot -- Mother Bruce -- The book with no pictures -- The day the crayons quit -- The scraps book : notes from a colorful life -- Three bears in a boat -- Blizzard -- Bright Sky, Starry City -- Hula-Hoopin Queen."
          }
        ]
      },
      {
        "fieldTag": "n",
        "marcTag": "520",
        "ind1": " ",
        "ind2": " ",
        "content": nil,
        "subfields": [
          {
            "tag": "a",
            "content": "Topic Set (20 books) - This set of titles are great for reading aloud and sharing in the classroom - grades 1 and grades 2.  These titles were former selections from the NYC Department of Education NYC Reads 365 list."
          }
        ]
      },
      {
        "fieldTag": "e",
        "marcTag": "250",
        "ind1": " ",
        "ind2": " ",
        "content": nil,
        "subfields": [
          {
            "tag": "a",
            "content": "1st Hyperion Paperbacks ed."
          }
        ]
      },
      {
        "fieldTag": "i",
        "marcTag": "020",
        "ind1": " ",
        "ind2": " ",
        "content": nil,
        "subfields": [
          {
            "tag": "a",
            "content": "9781489813930"
          }
        ]
      },
      {
        "fieldTag": "p",
        "marcTag": "260",
        "ind1": " ",
        "ind2": " ",
        "content": nil,
        "subfields": [
          {
            "tag": "a",
            "content": "McHenry, Ill. :"
          },
          {
            "tag": "b",
            "content": "Follett Library Resources,"
          },
          {
            "tag": "c",
            "content": "2013."
          }
        ]
      },
      {
        "fieldTag": "n",
        "marcTag": "521",
        "ind1": "2",
        "ind2": " ",
        "content": nil,
        "subfields": [
          {
            "tag": "a",
            "content": "K-1."
          }
        ]
      },
      {
        "fieldTag": "n",
        "marcTag": "521",
        "ind1": "2",
        "ind2": " ",
        "content": nil,
        "subfields": [
          {
            "tag": "a",
            "content": "1-2."
          }
        ]
      },
      {
        "fieldTag": "n",
        "marcTag": "521",
        "ind1": "8",
        "ind2": " ",
        "content": nil,
        "subfields": [
          {
            "tag": "a",
            "content": "70L-500L"
          },
          {
            "tag": "b",
            "content": "Lexile"
          }
        ]
      },
      {
        "fieldTag": "r",
        "marcTag": "300",
        "ind1": " ",
        "ind2": " ",
        "content": nil,
        "subfields": [
          {
            "tag": "a",
            "content": "20 v."
          }
        ]
      },
      {
        "fieldTag": "s",
        "marcTag": "490",
        "ind1": "0",
        "ind2": " ",
        "content": nil,
        "subfields": [
          {
            "tag": "a",
            "content": "Teacher Sets: MyLibraryNYC Program"
          }
        ]
      },
      {
        "fieldTag": "t",
        "marcTag": "245",
        "ind1": "0",
        "ind2": "0",
        "content": nil,
        "subfields": [
          {
            "tag": "a",
            "content": "Books for Reading and Sharing - Elementary School! 7"
          }
        ]
      },
      {
        "fieldTag": "u",
        "marcTag": "246",
        "ind1": "3",
        "ind2": "0",
        "content": nil,
        "subfields": [
          {
            "tag": "a",
            "content": "English Language Arts: Books for Reading and Sharing - Elementary School! Gr. 1-2 (Teacher Set)."
          }
        ]
      },
      {
        "fieldTag": "y",
        "marcTag": "901",
        "ind1": " ",
        "ind2": " ",
        "content": nil,
        "subfields": [
          {
            "tag": "a",
            "content": "ed"
          },
          {
            "tag": "b",
            "content": "SEL"
          }
        ]
      },
      {
        "fieldTag": "y",
        "marcTag": "944",
        "ind1": " ",
        "ind2": " ",
        "content": nil,
        "subfields": [
          {
            "tag": "a",
            "content": "9781896580601  9781896580602  9781896580603"
          }
        ]
      },
      {
        "fieldTag": "_",
        "marcTag": nil,
        "ind1": nil,
        "ind2": nil,
        "content": "00000nam  2200000 a 4500",
        "subfields": nil
      }
    ]
  }
]

ITEM_JSON_REQUEST_BODY = '{
  "data": [
   {
           "id": "18894057",
           "nyplSource": "sierra-nypl",
           "nyplType": "item",
           "updatedDate": "2019-06-26T15:37:46-04:00",
           "createdDate": "2015-08-28T19:07:06-04:00",
           "deletedDate": null,
           "deleted": false,
           "bibIds": [
               "19968034"
           ],
           "location": {
               "code": "eduls",
               "name": "LSC Educator Collection"
           },
           "status": {
               "code": "w",
               "display": "WITHDRAWN",
               "duedate": null
           },
           "barcode": "33333402216093",
           "callNumber": "Teacher Set ELA A Board Books 6-7",
           "itemType": null,
           "fixedFields": {
               "57": {
                   "label": "BIB HOLD",
                   "value": "false",
                   "display": null
               },
               "58": {
                   "label": "Copy No.",
                   "value": "1",
                   "display": null
               },
               "59": {
                   "label": "Item Code 1",
                   "value": "30007",
                   "display": null
               },
               "60": {
                   "label": "Item Code 2",
                   "value": "-",
                   "display": null
               },
               "61": {
                   "label": "Item Type",
                   "value": "252",
                   "display": "Teacher Set (DOE EDUCATOR ONLY)"
               },
               "62": {
                   "label": "Price",
                   "value": "0.000000",
                   "display": null
               },
               "64": {
                   "label": "Checkout Location",
                   "value": "0",
                   "display": null
               },
               "70": {
                   "label": "Checkin Location",
                   "value": "0",
                   "display": null
               },
               "74": {
                   "label": "Item Use 3",
                   "value": "0",
                   "display": null
               },
               "76": {
                   "label": "Total Checkouts",
                   "value": "0",
                   "display": null
               },
               "77": {
                   "label": "Total Renewals",
                   "value": "0",
                   "display": null
               },
               "79": {
                   "label": "Location",
                   "value": "eduls",
                   "display": "LSC Educator Collection"
               },
               "80": {
                   "label": "Record Type",
                   "value": "i",
                   "display": null
               },
               "81": {
                   "label": "Record Number",
                   "value": "33243159",
                   "display": null
               },
               "83": {
                   "label": "Created Date",
                   "value": "2015-08-28T19:07:06Z",
                   "display": null
               },
               "84": {
                   "label": "Updated Date",
                   "value": "2019-06-26T15:37:46Z",
                   "display": null
               },
               "85": {
                   "label": "No. of Revisions",
                   "value": "6",
                   "display": null
               },
               "86": {
                   "label": "Agency",
                   "value": "1",
                   "display": null
               },
               "88": {
                   "label": "Status",
                   "value": "w",
                   "display": "WITHDRAWN"
               },
               "93": {
                   "label": "Inhouse Use",
                   "value": "0",
                   "display": null
               },
               "94": {
                   "label": "Copy Use",
                   "value": "0",
                   "display": null
               },
               "97": {
                   "label": "Item Message",
                   "value": "c",
                   "display": null
               },
               "98": {
                   "label": "PDATE",
                   "value": "2019-02-26T20:28:00Z",
                   "display": null
               },
               "108": {
                   "label": "OPAC Message",
                   "value": "m",
                   "display": null
               },
               "109": {
                   "label": "Year-to-Date Circ",
                   "value": "0",
                   "display": null
               },
               "110": {
                   "label": "Last Year Circ",
                   "value": "0",
                   "display": null
               },
               "127": {
                   "label": "Item Agency",
                   "value": "44",
                   "display": "NYPL/Other"
               },
               "161": {
                   "label": "VI Central",
                   "value": "0",
                   "display": null
               },
               "162": {
                   "label": "IR Dist Learn Same Site",
                   "value": "0",
                   "display": null
               },
               "264": {
                   "label": "Holdings Item Tag",
                   "value": "6",
                   "display": null
               },
               "265": {
                   "label": "Inherit Location",
                   "value": "false",
                   "display": null
               }
           },
           "varFields": [
               {
                   "fieldTag": "b",
                   "marcTag": null,
                   "ind1": null,
                   "ind2": null,
                   "content": "33333402216093",
                   "subfields": null
               },
               {
                   "fieldTag": "c",
                   "marcTag": null,
                   "ind1": null,
                   "ind2": null,
                   "content": "Teacher Set ELA A Board Books 6-7",
                   "subfields": null
               },
               {
                   "fieldTag": "f",
                   "marcTag": null,
                   "ind1": null,
                   "ind2": null,
                   "content": "Purchased with DOE Funds (BPL fstms)",
                   "subfields": null
               },
               {
                   "fieldTag": "t",
                   "marcTag": null,
                   "ind1": null,
                   "ind2": null,
                   "content": "LOGDOE/XC",
                   "subfields": null
               },
               {
                   "fieldTag": "x",
                   "marcTag": null,
                   "ind1": null,
                   "ind2": null,
                   "content": "FORCE CHANGE FOR SCC 022619",
                   "subfields": null
               }
           ]
       }
   ],
  "count": 25,
  "totalCount": 0,
  "statusCode": 200,
  "debugInfo": []
}'

TWO_TEACHER_SETS_TO_DELETE = [{
    "id": "0",
    "title": "Example for non-existant bnumber"
  },
  {
      "id": "#{BNUMBER1}",
      "nyplSource": "sierra-nypl",
      "nyplType": "bib",
      "updatedDate": "2017-08-25T06:32:01-04:00",
      "createdDate": nil,
      "deletedDate": "2012-06-08",
      "deleted": true,
      "locations": [],
      "suppressed": nil,
      "lang": nil,
      "title": nil,
      "author": nil,
      "materialType": nil,
      "bibLevel": nil,
      "publishYear": nil,
      "catalogDate": nil,
      "country": nil,
      "normTitle": nil,
      "normAuthor": nil,
      "standardNumbers": [],
      "controlNumber": "",
      "fixedFields": {},
      "varFields": [],
      "count": 1,
      "totalCount": 0,
      "statusCode": 200,
      "debugInfo": []
    }
]

class ActionController::TestCase
  include Devise::Test::ControllerHelpers
end

class ActiveSupport::TestCase
  setup :mock_get_oauth_token_request, :mock_send_request_to_patron_creator_service, :send_request_to_bibs_microservice,
        :mock_send_request_to_items_microservice

  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  # Add more helper methods to be used by all tests here...

  # generate_email returns a string with 8 random charachters concatenated with the current timestamp
  # and domain schools.nyc.gov
  def self.generate_email
    return ('a'..'z').to_a.shuffle[0, 8].join + Time.now.to_i.to_s + '@schools.nyc.gov'
  end

  # generate_email returns a string with 8 random charachters concatenated with the current timestamp
  # and domain gmail.com
  def self.generate_email_without_valid_domain
    return ('a'..'z').to_a.shuffle[0, 8].join + Time.now.to_i.to_s + '@gmail.com'
  end

  # mock_get_oauth_token_request mocks an https request to 'https://isso.nypl.org/oauth/token'
  # and returns a JSON object with the key access_token
  def mock_get_oauth_token_request
    stub_request(:post, 'https://isso.nypl.org/oauth/token')
      .to_return(status: 200, body: { 'access_token' => 'testoken' }.to_json)
  end

  # mock_check_email_request takes in a parameter of e-mail and mocks an https
  # request to 'https://qa-platform.nypl.org/api/v0.1/patrons?email=' and returns a
  # 404 statusCode if the e-mail hasn't been created in Sierra.
  # TODO: Need to add 200 if the e-mail has been created
  def mock_check_email_request(email)
    stub_request(:get, "#{ENV['PATRON_MICROSERVICE_URL_V01']}?email=" + email)
      .to_return(status: 200, body: {
        'status' => 404,
        'type' => 'exception',
        'message' => 'No matching record found',
        'error' => [],
        'debugInfo' => []
      }
      .to_json, headers: { 'Content-Type' => 'application/json' })
  end

  # mock_send_request_to_patron_creator_service sends an https request
  # to 'https://qa-platform.nypl.org/api/v0.2/patrons' and returns a
  # status of success if Sierra API created a patron record.
  def mock_send_request_to_patron_creator_service
    stub_request(:post, ENV['PATRON_MICROSERVICE_URL_V02'])
      .to_return(
        {
          status: 201,
          body: {
            'status' => 'success'
          }.to_json,
          headers: {}
        },
        {
          status: 500,
          body: {
            'status' => 'failure'
          }.to_json, headers: {}
        }
      )
  end

  # send_request_to_bibs_microservice sends an https request
  # to "https://qa-platform.nypl.org/api/v0.1/bibs?standardNumber=9781896580601" and returns a
  # status of success if Sierra API finds the bib record.
  def send_request_to_bibs_microservice
    20.times do |x|
      stub_request(:get, "#{ENV['BIBS_MICROSERVICE_URL_V01']}?standardNumber=#{ 9781896580601 + x }").
        with(
          headers: {
      	  'Authorization'=>'Bearer testoken',
      	  'Content-Type'=>'application/json'
          }).to_return(status: 200, body: MODIFIED_BOOK_JSON_FOR_ISBN_9782917623268, headers: {}
      )
    end
    stub_request(:get, "#{ENV['BIBS_MICROSERVICE_URL_V01']}?standardNumber=123456789").
      with(
        headers: {
        'Authorization'=>'Bearer testoken',
        'Content-Type'=>'application/json'
        }).to_return(status: 200, body: JSON_FOR_BOOK_WITH_ISBN_AND_TITLE_TOO_LONG, headers: {}
    )
  end


  # send_request_to_items_microservice sends an https request
  # to "https://https://qa-platform.nypl.org/api/v0.1/items
  # status of success if Sierra API finds the bib record.
  def mock_send_request_to_items_microservice
    items_query_params = "?bibId=998&limit=25&offset=0"
    stub_request(:get, "#{ENV['ITEMS_MICROSERVICE_URL_V01']}" + items_query_params).
      with(
        headers: {
        'Authorization'=>'Bearer testoken',
        'Content-Type'=>'application/json'
        }).to_return(status: 200, body: ITEM_JSON_REQUEST_BODY, headers: {}
    )

    items_query_params = "?bibId=999&limit=25&offset=0"
    stub_request(:get, "#{ENV['ITEMS_MICROSERVICE_URL_V01']}" + items_query_params).
      with(
        headers: {
        'Authorization'=>'Bearer testoken',
        'Content-Type'=>'application/json'
        }).to_return(status: 200, body: ITEM_JSON_REQUEST_BODY, headers: {}
    )
  end

end

begin
  puts "Starting test run..."

  puts "Starting DatabaseCleaner..."
  DatabaseCleaner.strategy = :truncation
  DatabaseCleaner.start
ensure
  puts "Cleaning up with DatabaseCleaner..."
  DatabaseCleaner.clean
end
