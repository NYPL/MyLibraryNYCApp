require 'test_helper'

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
        "ind2": "0",
        "content": nil,
        "subfields": [
          {
            "tag": "a",
            "content": "Picture books for children."
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
            "content": "1-2."
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
        "ind2": "0",
        "content": nil,
        "subfields": [
          {
            "tag": "a",
            "content": "Picture books for children."
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
            "content": "1-2."
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
        "ind2": "0",
        "content": nil,
        "subfields": [
          {
            "tag": "a",
            "content": "Picture books for children."
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
            "content": "1-2."
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
        "ind2": "0",
        "content": nil,
        "subfields": [
          {
            "tag": "a",
            "content": "Picture books for children."
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
            "content": "1-2."
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
        "ind2": "0",
        "content": nil,
        "subfields": [
          {
            "tag": "a",
            "content": "Picture books for children."
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
            "content": "1-2."
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
            "content": "9781896580609  9781442429789  9781484730881"
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

class Api::BibsControllerTest < ActionController::TestCase
  def setup
    @controller = Api::V01::BibsController.new
  end

  # test 'respond with 400 if request body is missing' do
  #   post 'create_or_update_teacher_sets'
  #   assert response.status == 400
  # end

  test "should update teacher set attributes and create associated books" do
    Book.destroy_all
    TeacherSet.destroy_all
    post 'create_or_update_teacher_sets', { _json: TWO_TEACHER_SETS_WITH_10_ISBNS_EACH }
    assert_response :success
    assert Book.count == 20
    assert TeacherSet.count == 2
    assert TeacherSet.first.books.count == 10
    assert TeacherSetBook.count == 20 # each teacher set has 10 books
    assert JSON.parse(response.body)['teacher_sets'].map{ |x| x['bnumber'] } == ["b#{BNUMBER1}", "b#{BNUMBER2}"]

    # simulate an update which removes seven books from each teacher_set
    post 'create_or_update_teacher_sets', { _json: TWO_TEACHER_SETS_WITH_3_ISBNS_EACH }
    assert_response :success
    assert Book.count == 20 # no change to books but TeacherSetBooks decrease
    assert TeacherSet.count == 2 # no change
    assert TeacherSet.first.books.count == 3
    assert TeacherSetBook.count == 6 # some records are deleted in the join table (compare to 20 records above)
    assert JSON.parse(response.body)['teacher_sets'].map{ |x| x['bnumber'] } == ["b#{BNUMBER1}", "b#{BNUMBER2}"]

    # confirm all fields are updated
    first_teacher_set = TeacherSet.first
    assert first_teacher_set.title.present?
    assert first_teacher_set.call_number.present?
    assert first_teacher_set.description.present?
    assert first_teacher_set.edition.present?
    assert first_teacher_set.isbn.present?
    assert first_teacher_set.primary_language.present?
    assert first_teacher_set.publisher.present?
    assert first_teacher_set.contents.present?
    assert first_teacher_set.primary_subject.present?
    assert first_teacher_set.physical_description.present?
    assert first_teacher_set.details_url.present?
    assert first_teacher_set.grade_begin.present?
    assert first_teacher_set.grade_end.present?
    assert first_teacher_set.lexile_begin.present?
    assert first_teacher_set.lexile_end.present?
    assert first_teacher_set.availability.present?
    assert first_teacher_set.teacher_set_notes.any?
    assert first_teacher_set.subject_teacher_sets.map(&:subject).any? # for some reason, this syntax won't work: `first_teacher_set.subjects.any?`
  end

  # test "should not create a teacher set if required field is missing (ie title)" do
  #   Book.destroy_all
  #   TeacherSet.destroy_all
  #   post 'create_or_update_teacher_sets', { _json: TEACHER_SET_WITH_TITLE_MISSING }
  #   assert_response :success
  #   assert Book.count == 0
  #   assert TeacherSet.count == 0
  # end
  #
  # test "should delete teacher sets when given a bib number" do
  #   TeacherSet.where(bnumber: "b#{BNUMBER1}").first_or_create
  #   delete 'delete_teacher_sets', { _json: TWO_TEACHER_SETS_TO_DELETE }
  #   assert_response :success
  #   assert JSON.parse(response.body)['teacher_sets'].map{ |x| x['bnumber'] } == ["b#{BNUMBER1}"]
  # end
end
