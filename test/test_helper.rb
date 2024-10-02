# frozen_string_literal: true

require 'simplecov'
# NOTE: minimum coverage config can also maybe happen outside, and before the start block.
SimpleCov.start 'rails' do
  add_filter '/bin/'
  add_filter '/db/'
  add_filter '/test/' # for minitest
  add_filter 'lib/tasks/cleanup.rake'
  add_filter 'lib/tasks/sync_users.rake'
end
# fail unit tests if total coverage dips below acceptable limit
# SimpleCov.minimum_coverage 62.7 #for testing

# fail unit tests if any file's individual coverage dips below acceptable limit
SimpleCov.minimum_coverage_by_file 0


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
              "content": "Despite the medical miracle that has bought her a few more years, Hazel has never been
               anything but terminal, but when Augustus Waters suddenly appears at the Cancer Kid Support Group,
                Hazels story is about to be rewritten."
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
    id: "#{BNUMBER1}",
    nyplSource: "sierra-nypl",
    nyplType: "bib",
    updatedDate: "2017-08-23T20:22:13-04:00",
    createdDate: "2017-08-23T14:46:46-04:00",
    deletedDate: nil,
    deleted: false,
    locations: [
      {
        code: "ed",
        name: "LSC Educator Collection"
      }
    ],
    suppressed: false,
    lang: {
      code: "eng",
      name: "English"
    },
    title: "Books for Reading and Sharing - Elementary School! 1",
    author: "",
    materialType: {
      code: "8",
      value: "TEACHER SET"
    },
    bibLevel: {
      code: "m",
      value: "MONOGRAPH"
    },
    publishYear: nil,
    catalogDate: "2017-08-23",
    country: {
      code: "xx ",
      name: "Unknown or undetermined"
    },
    normTitle: "books for reading and sharing elementary school",
    normAuthor: "",
    standardNumbers: [],
    controlNumber: "",
    fixedFields: {
      '24': {
        label: "Language",
        value: "eng",
        display: "English"
      },
      '25': {
        label: "Skip",
        value: "0",
        display: nil
      },
      '26': {
        label: "Location",
        value: "ed   ",
        display: "LSC Educator Collection"
      },
      '27': {
        label: "COPIES",
        value: "0",
        display: nil
      },
      '28': {
        label: "Cat. Date",
        value: "2017-08-23",
        display: nil
      },
      '29': {
        label: "Bib Level",
        value: "m",
        display: "MONOGRAPH"
      },
      '30': {
        label: "Material Type",
        value: "8",
        display: "TEACHER SET"
      },
      '31': {
        label: "Bib Code 3",
        value: "-",
        display: nil
      },
      '80': {
        label: "Record Type",
        value: "b",
        display: nil
      },
      '81': {
        label: "Record Number",
        value: "21323534",
        display: nil
      },
      '83': {
        label: "Created Date",
        value: "2017-08-23T14:46:46Z",
        display: nil
      },
      '84': {
        label: "Updated Date",
        value: "2017-08-23T20:22:13Z",
        display: nil
      },
      '85': {
        label: "No. of Revisions",
        value: "2",
        display: nil
      },
      '86': {
        label: "Agency",
        value: "1",
        display: nil
      },
      '89': {
        label: "Country",
        value: "xx ",
        display: "Unknown or undetermined"
      },
      '98': {
        label: "PDATE",
        value: "2017-08-23T20:20:00Z",
        display: nil
      },
      '107': {
        label: "MARC Type",
        value: " ",
        display: nil
      }
    },
    varFields: [
      {
        fieldTag: "c",
        marcTag: "091",
        ind1: " ",
        ind2: " ",
        content: nil,
        subfields: [
          {
            tag: "a",
            content: "Teacher Set ELA A Books 4"
          }
        ]
      },
      {
        fieldTag: "d",
        marcTag: "650",
        ind1: " ",
        ind2: "1",
        content: nil,
        subfields: [
          {
            tag: "a",
            content: "Political activists."
          }
        ]
      },
      {
        fieldTag: "d",
        marcTag: "650",
        ind1: " ",
        ind2: "1",
        content: nil,
        subfields: [
          {
            tag: "a",
            content: "Race relations."
          }
        ]
      },
      {
        fieldTag: "d",
        marcTag: "690",
        ind1: "0",
        ind2: "7",
        content: nil,
        subfields: [
          {
            tag: "a",
            content: "English Language Arts."
          },
          {
            tag: "2",
            content: "local"
          }
        ]
      },
      {
        fieldTag: "n",
        marcTag: "500",
        ind1: " ",
        ind2: " ",
        content: nil,
        subfields: [
          {
            tag: "a",
            content: "2 copies of 10 titles."
          }
        ]
      },
      {
        fieldTag: "n",
        marcTag: "505",
        ind1: " ",
        ind2: " ",
        content: nil,
        subfields: [
          {
            tag: "a",
            content: "Anna carries water -- Monkey & Robot -- Mother Bruce -- The book with no pictures --
             The day the crayons quit -- The scraps book : notes from a colorful life -- Three bears in a boat --
              Blizzard -- Bright Sky, Starry City -- Hula-Hoopin Queen."
          }
        ]
      },
      {
        fieldTag: "n",
        marcTag: "520",
        ind1: " ",
        ind2: " ",
        content: nil,
        subfields: [
          {
            tag: "a",
            content: "Topic Set (20 books) - This set of titles are great for reading aloud and sharing
             in the classroom - grades 1 and grades 2.  These titles were former selections from the NYC Department of
              Education NYC Reads 365 list."
          }
        ]
      },
      {
        fieldTag: "e",
        marcTag: "250",
        ind1: " ",
        ind2: " ",
        content: nil,
        subfields: [
          {
            tag: "a",
            content: "1st Hyperion Paperbacks ed."
          }
        ]
      },
      {
        fieldTag: "i",
        marcTag: "020",
        ind1: " ",
        ind2: " ",
        content: nil,
        subfields: [
          {
            tag: "a",
            content: "9781489813930"
          }
        ]
      },
      {
        fieldTag: "p",
        marcTag: "260",
        ind1: " ",
        ind2: " ",
        content: nil,
        subfields: [
          {
            tag: "a",
            content: "McHenry, Ill. :"
          },
          {
            tag: "b",
            content: "Follett Library Resources,"
          },
          {
            tag: "c",
            content: "2013."
          }
        ]
      },
      {
        fieldTag: "n",
        marcTag: "521",
        ind1: "2",
        ind2: " ",
        content: nil,
        subfields: [
          {
            tag: "a",
            content: "K-1."
          }
        ]
      },
      {
        fieldTag: "n",
        marcTag: "521",
        ind1: "2",
        ind2: " ",
        content: nil,
        subfields: [
          {
            tag: "a",
            content: "1-2."
          }
        ]
      },
      {
        fieldTag: "n",
        marcTag: "521",
        ind1: "8",
        ind2: " ",
        content: nil,
        subfields: [
          {
            tag: "a",
            content: "70L-500L"
          },
          {
            tag: "b",
            content: "Lexile"
          }
        ]
      },
      {
        fieldTag: "r",
        marcTag: "300",
        ind1: " ",
        ind2: " ",
        content: nil,
        subfields: [
          {
            tag: "a",
            content: "20 v."
          }
        ]
      },
      {
        fieldTag: "s",
        marcTag: "490",
        ind1: "0",
        ind2: " ",
        content: nil,
        subfields: [
          {
            tag: "a",
            content: "Teacher Sets: MyLibraryNYC Program"
          }
        ]
      },
      {
        fieldTag: "t",
        marcTag: "245",
        ind1: "0",
        ind2: "0",
        content: nil,
        subfields: [
          {
            tag: "a",
            content: "Books for Reading and Sharing - Elementary School! 2"
          }
        ]
      },
      {
        fieldTag: "u",
        marcTag: "246",
        ind1: "3",
        ind2: "0",
        content: nil,
        subfields: [
          {
            tag: "a",
            content: "English Language Arts: Books for Reading and Sharing - Elementary School! Gr. 1-2 (Teacher Set)."
          }
        ]
      },
      {
        fieldTag: "y",
        marcTag: "901",
        ind1: " ",
        ind2: " ",
        content: nil,
        subfields: [
          {
            tag: "a",
            content: "ed"
          },
          {
            tag: "b",
            content: "SEL"
          }
        ]
      },
      {
        fieldTag: "y",
        marcTag: "944",
        ind1: " ",
        ind2: " ",
        content: nil,
        subfields: [
          {
            tag: "a",
            content: "9781896580601 9781896580602 9781896580603 9781896580604 9781896580605 9781896580606
             9781896580607 9781896580608 9781896580609 9781896580610"
          }
        ]
      },
      {
        fieldTag: "_",
        marcTag: nil,
        ind1: nil,
        ind2: nil,
        content: "00000nam  2200000 a 4500",
        subfields: nil
      }
    ]
  },
  {
    id: "#{BNUMBER2}",
    nyplSource: "sierra-nypl",
    nyplType: "bib",
    updatedDate: "2017-08-23T20:22:13-04:00",
    createdDate: "2017-08-23T14:46:46-04:00",
    deletedDate: nil,
    deleted: false,
    locations: [
      {
        code: "ed",
        name: "LSC Educator Collection"
      }
    ],
    suppressed: false,
    lang: {
      code: "eng",
      name: "English"
    },
    title: "Title 2",
    author: "",
    materialType: {
      code: "8",
      value: "TEACHER SET"
    },
    bibLevel: {
      code: "m",
      value: "MONOGRAPH"
    },
    publishYear: nil,
    catalogDate: "2017-08-23",
    country: {
      code: "xx ",
      name: "Unknown or undetermined"
    },
    normTitle: "books for reading and sharing elementary school",
    normAuthor: "",
    standardNumbers: [],
    controlNumber: "",
    fixedFields: {
      '24': {
        label: "Language",
        value: "eng",
        display: "English"
      },
      '25': {
        label: "Skip",
        value: "0",
        display: nil
      },
      '26': {
        label: "Location",
        value: "ed   ",
        display: "LSC Educator Collection"
      },
      '27': {
        label: "COPIES",
        value: "0",
        display: nil
      },
      '28': {
        label: "Cat. Date",
        value: "2017-08-23",
        display: nil
      },
      '29': {
        label: "Bib Level",
        value: "m",
        display: "MONOGRAPH"
      },
      '30': {
        label: "Material Type",
        value: "8",
        display: "TEACHER SET"
      },
      '31': {
        label: "Bib Code 3",
        value: "-",
        display: nil
      },
      '80': {
        label: "Record Type",
        value: "b",
        display: nil
      },
      '81': {
        label: "Record Number",
        value: "21323534",
        display: nil
      },
      '83': {
        label: "Created Date",
        value: "2017-08-23T14:46:46Z",
        display: nil
      },
      '84': {
        label: "Updated Date",
        value: "2017-08-23T20:22:13Z",
        display: nil
      },
      '85': {
        label: "No. of Revisions",
        value: "2",
        display: nil
      },
      '86': {
        label: "Agency",
        value: "1",
        display: nil
      },
      '89': {
        label: "Country",
        value: "xx ",
        display: "Unknown or undetermined"
      },
      '98': {
        label: "PDATE",
        value: "2017-08-23T20:20:00Z",
        display: nil
      },
      '107': {
        label: "MARC Type",
        value: " ",
        display: nil
      }
    },
    varFields: [
      {
        fieldTag: "c",
        marcTag: "091",
        ind1: " ",
        ind2: " ",
        content: nil,
        subfields: [
          {
            tag: "a",
            content: "Teacher Set ELA A Books 4"
          }
        ]
      },
      {
        fieldTag: "d",
        marcTag: "650",
        ind1: " ",
        ind2: "1",
        content: nil,
        subfields: [
          {
            tag: "a",
            content: "Political activists."
          }
        ]
      },
      {
        fieldTag: "d",
        marcTag: "650",
        ind1: " ",
        ind2: "1",
        content: nil,
        subfields: [
          {
            tag: "a",
            content: "Race relations."
          }
        ]
      },
      {
        fieldTag: "d",
        marcTag: "690",
        ind1: "0",
        ind2: "7",
        content: nil,
        subfields: [
          {
            tag: "a",
            content: "English Language Arts."
          },
          {
            tag: "2",
            content: "local"
          }
        ]
      },
      {
        fieldTag: "n",
        marcTag: "500",
        ind1: " ",
        ind2: " ",
        content: nil,
        subfields: [
          {
            tag: "a",
            content: "2 copies of 10 titles."
          }
        ]
      },
      {
        fieldTag: "n",
        marcTag: "505",
        ind1: " ",
        ind2: " ",
        content: nil,
        subfields: [
          {
            tag: "a",
            content: "Anna carries water -- Monkey & Robot -- Mother Bruce -- The book with no pictures --
             The day the crayons quit -- The scraps book : notes from a colorful life -- Three bears in a boat
              -- Blizzard -- Bright Sky, Starry City -- Hula-Hoopin Queen."
          }
        ]
      },
      {
        fieldTag: "n",
        marcTag: "520",
        ind1: " ",
        ind2: " ",
        content: nil,
        subfields: [
          {
            tag: "a",
            content: "Topic Set (20 books) - This set of titles are great for reading aloud and sharing in the classroom
             - grades 1 and grades 2.  These titles were former selections from the NYC Department of Education NYC Reads 365 list."
          }
        ]
      },
      {
        fieldTag: "e",
        marcTag: "250",
        ind1: " ",
        ind2: " ",
        content: nil,
        subfields: [
          {
            tag: "a",
            content: "1st Hyperion Paperbacks ed."
          }
        ]
      },
      {
        fieldTag: "i",
        marcTag: "020",
        ind1: " ",
        ind2: " ",
        content: nil,
        subfields: [
          {
            tag: "a",
            content: "9781489813930"
          }
        ]
      },
      {
        fieldTag: "p",
        marcTag: "260",
        ind1: " ",
        ind2: " ",
        content: nil,
        subfields: [
          {
            tag: "a",
            content: "McHenry, Ill. :"
          },
          {
            tag: "b",
            content: "Follett Library Resources,"
          },
          {
            tag: "c",
            content: "2013."
          }
        ]
      },
      {
        fieldTag: "n",
        marcTag: "521",
        ind1: "2",
        ind2: " ",
        content: nil,
        subfields: [
          {
            tag: "a",
            content: "K-1."
          }
        ]
      },
      {
        fieldTag: "n",
        marcTag: "521",
        ind1: "2",
        ind2: " ",
        content: nil,
        subfields: [
          {
            tag: "a",
            content: "1-2."
          }
        ]
      },
      {
        fieldTag: "n",
        marcTag: "521",
        ind1: "8",
        ind2: " ",
        content: nil,
        subfields: [
          {
            tag: "a",
            content: "70L-500L"
          },
          {
            tag: "b",
            content: "Lexile"
          }
        ]
      },
      {
        fieldTag: "r",
        marcTag: "300",
        ind1: " ",
        ind2: " ",
        content: nil,
        subfields: [
          {
            tag: "a",
            content: "20 v."
          }
        ]
      },
      {
        fieldTag: "s",
        marcTag: "490",
        ind1: "0",
        ind2: " ",
        content: nil,
        subfields: [
          {
            tag: "a",
            content: "Teacher Sets: MyLibraryNYC Program"
          }
        ]
      },
      {
        fieldTag: "t",
        marcTag: "245",
        ind1: "0",
        ind2: "0",
        content: nil,
        subfields: [
          {
            tag: "a",
            content: "Books for Reading and Sharing - Elementary School! 3"
          }
        ]
      },
      {
        fieldTag: "u",
        marcTag: "246",
        ind1: "3",
        ind2: "0",
        content: nil,
        subfields: [
          {
            tag: "a",
            content: "English Language Arts: Books for Reading and Sharing - Elementary School! Gr. 1-2 (Teacher Set)."
          }
        ]
      },
      {
        fieldTag: "y",
        marcTag: "901",
        ind1: " ",
        ind2: " ",
        content: nil,
        subfields: [
          {
            tag: "a",
            content: "ed"
          },
          {
            tag: "b",
            content: "SEL"
          }
        ]
      },
      {
        fieldTag: "y",
        marcTag: "944",
        ind1: " ",
        ind2: " ",
        content: nil,
        subfields: [
          {
            tag: "a",
            content: "9781896580611 9781896580612 9781896580613 9781896580614 9781896580615 9781896580616 9781896580617
             9781896580618 9781896580619 9781896580620"
          }
        ]
      },
      {
        fieldTag: "_",
        marcTag: nil,
        ind1: nil,
        ind2: nil,
        content: "00000nam  2200000 a 4500",
        subfields: nil
      }
    ]
  }
]

ONE_TEACHER_SET_WITH_A_BOOK_ISBN_OF_300_CHARACTERS = [
  {
    id: "#{BNUMBER1}",
    nyplSource: "sierra-nypl",
    nyplType: "bib",
    updatedDate: "2017-08-23T20:22:13-04:00",
    createdDate: "2017-08-23T14:46:46-04:00",
    deletedDate: nil,
    deleted: false,
    locations: [
      {
        code: "ed",
        name: "LSC Educator Collection"
      }
    ],
    suppressed: false,
    lang: {
      code: "eng",
      name: "English"
    },
    title: "Books for Reading and Sharing - Elementary School! 1",
    author: "",
    materialType: {
      code: "8",
      value: "TEACHER SET"
    },
    bibLevel: {
      code: "m",
      value: "MONOGRAPH"
    },
    publishYear: nil,
    catalogDate: "2017-08-23",
    country: {
      code: "xx ",
      name: "Unknown or undetermined"
    },
    normTitle: "books for reading and sharing elementary school",
    normAuthor: "",
    standardNumbers: [],
    controlNumber: "",
    fixedFields: {
      '24': {
        label: "Language",
        value: "eng",
        display: "English"
      },
      '25': {
        label: "Skip",
        value: "0",
        display: nil
      },
      '26': {
        label: "Location",
        value: "ed   ",
        display: "LSC Educator Collection"
      },
      '27': {
        label: "COPIES",
        value: "0",
        display: nil
      },
      '28': {
        label: "Cat. Date",
        value: "2017-08-23",
        display: nil
      },
      '29': {
        label: "Bib Level",
        value: "m",
        display: "MONOGRAPH"
      },
      '30': {
        label: "Material Type",
        value: "8",
        display: "TEACHER SET"
      },
      '31': {
        label: "Bib Code 3",
        value: "-",
        display: nil
      },
      '80': {
        label: "Record Type",
        value: "b",
        display: nil
      },
      '81': {
        label: "Record Number",
        value: "21323534",
        display: nil
      },
      '83': {
        label: "Created Date",
        value: "2017-08-23T14:46:46Z",
        display: nil
      },
      '84': {
        label: "Updated Date",
        value: "2017-08-23T20:22:13Z",
        display: nil
      },
      '85': {
        label: "No. of Revisions",
        value: "2",
        display: nil
      },
      '86': {
        label: "Agency",
        value: "1",
        display: nil
      },
      '89': {
        label: "Country",
        value: "xx ",
        display: "Unknown or undetermined"
      },
      '98': {
        label: "PDATE",
        value: "2017-08-23T20:20:00Z",
        display: nil
      },
      '107': {
        label: "MARC Type",
        value: " ",
        display: nil
      }
    },
    varFields: [
      {
        fieldTag: "c",
        marcTag: "091",
        ind1: " ",
        ind2: " ",
        content: nil,
        subfields: [
          {
            tag: "a",
            content: "Teacher Set ELA A Books 4"
          }
        ]
      },
      {
        fieldTag: "d",
        marcTag: "650",
        ind1: " ",
        ind2: "1",
        content: nil,
        subfields: [
          {
            tag: "a",
            content: "Political activists."
          }
        ]
      },
      {
        fieldTag: "d",
        marcTag: "650",
        ind1: " ",
        ind2: "1",
        content: nil,
        subfields: [
          {
            tag: "a",
            content: "Race relations."
          }
        ]
      },
      {
        fieldTag: "d",
        marcTag: "690",
        ind1: "0",
        ind2: "7",
        content: nil,
        subfields: [
          {
            tag: "a",
            content: "English Language Arts."
          },
          {
            tag: "2",
            content: "local"
          }
        ]
      },
      {
        fieldTag: "n",
        marcTag: "500",
        ind1: " ",
        ind2: " ",
        content: nil,
        subfields: [
          {
            tag: "a",
            content: "2 copies of 10 titles."
          }
        ]
      },
      {
        fieldTag: "n",
        marcTag: "505",
        ind1: " ",
        ind2: " ",
        content: nil,
        subfields: [
          {
            tag: "a",
            content: "Anna carries water -- Monkey & Robot -- Mother Bruce -- The book with no pictures --
             The day the crayons quit -- The scraps book : notes from a colorful life -- Three bears in a boat --
              Blizzard -- Bright Sky, Starry City -- Hula-Hoopin Queen."
          }
        ]
      },
      {
        fieldTag: "n",
        marcTag: "520",
        ind1: " ",
        ind2: " ",
        content: nil,
        subfields: [
          {
            tag: "a",
            content: "Topic Set (20 books) - This set of titles are great for reading aloud and sharing in the classroom -
             grades 1 and grades 2.  These titles were former selections from the NYC Department of Education NYC Reads 365 list."
          }
        ]
      },
      {
        fieldTag: "e",
        marcTag: "250",
        ind1: " ",
        ind2: " ",
        content: nil,
        subfields: [
          {
            tag: "a",
            content: "1st Hyperion Paperbacks ed."
          }
        ]
      },
      {
        fieldTag: "i",
        marcTag: "020",
        ind1: " ",
        ind2: " ",
        content: nil,
        subfields: [
          {
            tag: "a",
            content: "9781489813930"
          }
        ]
      },
      {
        fieldTag: "p",
        marcTag: "260",
        ind1: " ",
        ind2: " ",
        content: nil,
        subfields: [
          {
            tag: "a",
            content: "McHenry, Ill. :"
          },
          {
            tag: "b",
            content: "Follett Library Resources,"
          },
          {
            tag: "c",
            content: "2013."
          }
        ]
      },
      {
        fieldTag: "n",
        marcTag: "521",
        ind1: "2",
        ind2: " ",
        content: nil,
        subfields: [
          {
            tag: "a",
            content: "K-1."
          }
        ]
      },
      {
        fieldTag: "n",
        marcTag: "521",
        ind1: "2",
        ind2: " ",
        content: nil,
        subfields: [
          {
            tag: "a",
            content: "1-2."
          }
        ]
      },
      {
        fieldTag: "n",
        marcTag: "521",
        ind1: "8",
        ind2: " ",
        content: nil,
        subfields: [
          {
            tag: "a",
            content: "70L-500L"
          },
          {
            tag: "b",
            content: "Lexile"
          }
        ]
      },
      {
        fieldTag: "r",
        marcTag: "300",
        ind1: " ",
        ind2: " ",
        content: nil,
        subfields: [
          {
            tag: "a",
            content: "20 v."
          }
        ]
      },
      {
        fieldTag: "s",
        marcTag: "490",
        ind1: "0",
        ind2: " ",
        content: nil,
        subfields: [
          {
            tag: "a",
            content: "Teacher Sets: MyLibraryNYC Program"
          }
        ]
      },
      {
        fieldTag: "t",
        marcTag: "245",
        ind1: "0",
        ind2: "0",
        content: nil,
        subfields: [
          {
            tag: "a",
            content: "Books for Reading and Sharing - Elementary School! 2"
          }
        ]
      },
      {
        fieldTag: "u",
        marcTag: "246",
        ind1: "3",
        ind2: "0",
        content: nil,
        subfields: [
          {
            tag: "a",
            content: "English Language Arts: Books for Reading and Sharing - Elementary School! Gr. 1-2 (Teacher Set)."
          }
        ]
      },
      {
        fieldTag: "y",
        marcTag: "901",
        ind1: " ",
        ind2: " ",
        content: nil,
        subfields: [
          {
            tag: "a",
            content: "ed"
          },
          {
            tag: "b",
            content: "SEL"
          }
        ]
      },
      {
        fieldTag: "y",
        marcTag: "944",
        ind1: " ",
        ind2: " ",
        content: nil,
        subfields: [
          {
            tag: "a",
            content: "123456789"
          }
        ]
      },
      {
        fieldTag: "_",
        marcTag: nil,
        ind1: nil,
        ind2: nil,
        content: "00000nam  2200000 a 4500",
        subfields: nil
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
      "title": "Title is intentionally > 255 characters 123456789 123456789 123456789 123456789 123456789 123456789 123456789
       123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789
        123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 ",
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
        "This ISBN intentionally > 255 characters 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789
         123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789
          123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 ",
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
              "content": "Despite the medical miracle that has bought her a few more years, Hazel has never been anything but terminal,
               but when Augustus Waters suddenly appears at the Cancer Kid Support Group, Hazels story is about to be rewritten."
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
    id: "#{BNUMBER1}",
    nyplSource: "sierra-nypl",
    nyplType: "bib",
    updatedDate: "2017-08-23T20:22:13-04:00",
    createdDate: "2017-08-23T14:46:46-04:00",
    deletedDate: nil,
    deleted: false,
    locations: [
      {
        code: "ed",
        name: "LSC Educator Collection"
      }
    ],
    suppressed: false,
    lang: {
      code: "eng",
      name: "English"
    },
    title: "Books for Reading and Sharing - Elementary School! 4",
    author: "",
    materialType: {
      code: "8",
      value: "TEACHER SET"
    },
    bibLevel: {
      code: "m",
      value: "MONOGRAPH"
    },
    publishYear: nil,
    catalogDate: "2017-08-23",
    country: {
      code: "xx ",
      name: "Unknown or undetermined"
    },
    normTitle: "books for reading and sharing elementary school",
    normAuthor: "",
    standardNumbers: [],
    controlNumber: "",
    fixedFields: {
      '24': {
        label: "Language",
        value: "eng",
        display: "English"
      },
      '25': {
        label: "Skip",
        value: "0",
        display: nil
      },
      '26': {
        label: "Location",
        value: "ed   ",
        display: "LSC Educator Collection"
      },
      '27': {
        label: "COPIES",
        value: "0",
        display: nil
      },
      '28': {
        label: "Cat. Date",
        value: "2017-08-23",
        display: nil
      },
      '29': {
        label: "Bib Level",
        value: "m",
        display: "MONOGRAPH"
      },
      '30': {
        label: "Material Type",
        value: "8",
        display: "TEACHER SET"
      },
      '31': {
        label: "Bib Code 3",
        value: "-",
        display: nil
      },
      '80': {
        label: "Record Type",
        value: "b",
        display: nil
      },
      '81': {
        label: "Record Number",
        value: "21323534",
        display: nil
      },
      '83': {
        label: "Created Date",
        value: "2017-08-23T14:46:46Z",
        display: nil
      },
      '84': {
        label: "Updated Date",
        value: "2017-08-23T20:22:13Z",
        display: nil
      },
      '85': {
        label: "No. of Revisions",
        value: "2",
        display: nil
      },
      '86': {
        label: "Agency",
        value: "1",
        display: nil
      },
      '89': {
        label: "Country",
        value: "xx ",
        display: "Unknown or undetermined"
      },
      '98': {
        label: "PDATE",
        value: "2017-08-23T20:20:00Z",
        display: nil
      },
      '107': {
        label: "MARC Type",
        value: " ",
        display: nil
      }
    },
    varFields: [
      {
        fieldTag: "d",
        marcTag: "655",
        ind1: " ",
        ind2: "7",
        content: nil,
        subfields: [
          {
            tag: "a",
            content: "Stories in rhyme."
          },
          {
            tag: "2",
            content: "lcgft"
          }
        ]
      },
      {
        fieldTag: "c",
        marcTag: "091",
        ind1: " ",
        ind2: " ",
        content: nil,
        subfields: [
          {
            tag: "a",
            content: "Teacher Set ELA A Books 4"
          }
        ]
      },
      {
        fieldTag: "d",
        marcTag: "650",
        ind1: " ",
        ind2: "1",
        content: nil,
        subfields: [
          {
            tag: "a",
            content: "Political activists."
          }
        ]
      },
      {
        fieldTag: "d",
        marcTag: "650",
        ind1: " ",
        ind2: "1",
        content: nil,
        subfields: [
          {
            tag: "a",
            content: "Race relations."
          }
        ]
      },
      {
        fieldTag: "d",
        marcTag: "690",
        ind1: "0",
        ind2: "7",
        content: nil,
        subfields: [
          {
            tag: "a",
            content: "English Language Arts."
          },
          {
            tag: "2",
            content: "local"
          }
        ]
      },
      {
        fieldTag: "n",
        marcTag: "500",
        ind1: " ",
        ind2: " ",
        content: nil,
        subfields: [
          {
            tag: "a",
            content: "2 copies of 10 titles."
          }
        ]
      },
      {
        fieldTag: "n",
        marcTag: "505",
        ind1: " ",
        ind2: " ",
        content: nil,
        subfields: [
          {
            tag: "a",
            content: "Anna carries water -- Monkey & Robot -- Mother Bruce -- The book with no pictures -- The day the crayons quit --
             The scraps book : notes from a colorful life -- Three bears in a boat -- Blizzard -- Bright Sky, Starry City -- Hula-Hoopin Queen."
          }
        ]
      },
      {
        fieldTag: "n",
        marcTag: "520",
        ind1: " ",
        ind2: " ",
        content: nil,
        subfields: [
          {
            tag: "a",
            content: "Topic Set (20 books) - This set of titles are great for reading aloud and sharing in the classroom - 
            grades 1 and grades 2.  These titles were former selections from the NYC Department of Education NYC Reads 365 list."
          }
        ]
      },
      {
        fieldTag: "e",
        marcTag: "250",
        ind1: " ",
        ind2: " ",
        content: nil,
        subfields: [
          {
            tag: "a",
            content: "1st Hyperion Paperbacks ed."
          }
        ]
      },
      {
        fieldTag: "i",
        marcTag: "020",
        ind1: " ",
        ind2: " ",
        content: nil,
        subfields: [
          {
            tag: "a",
            content: "9781489813930"
          }
        ]
      },
      {
        fieldTag: "p",
        marcTag: "260",
        ind1: " ",
        ind2: " ",
        content: nil,
        subfields: [
          {
            tag: "a",
            content: "McHenry, Ill. :"
          },
          {
            tag: "b",
            content: "Follett Library Resources,"
          },
          {
            tag: "c",
            content: "2013."
          }
        ]
      },
      {
        fieldTag: "n",
        marcTag: "521",
        ind1: "2",
        ind2: " ",
        content: nil,
        subfields: [
          {
            tag: "a",
            content: "K-1."
          }
        ]
      },
      {
        fieldTag: "n",
        marcTag: "521",
        ind1: "2",
        ind2: " ",
        content: nil,
        subfields: [
          {
            tag: "a",
            content: "1-2."
          }
        ]
      },
      {
        fieldTag: "n",
        marcTag: "521",
        ind1: "8",
        ind2: " ",
        content: nil,
        subfields: [
          {
            tag: "a",
            content: "70L-500L"
          },
          {
            tag: "b",
            content: "Lexile"
          }
        ]
      },
      {
        fieldTag: "r",
        marcTag: "300",
        ind1: " ",
        ind2: " ",
        content: nil,
        subfields: [
          {
            tag: "a",
            content: "20 v."
          }
        ]
      },
      {
        fieldTag: "s",
        marcTag: "490",
        ind1: "0",
        ind2: " ",
        content: nil,
        subfields: [
          {
            tag: "a",
            content: "Teacher Sets: MyLibraryNYC Program"
          }
        ]
      },
      {
        fieldTag: "t",
        marcTag: "245",
        ind1: "0",
        ind2: "0",
        content: nil,
        subfields: [
          {
            tag: "a",
            content: "Books for Reading and Sharing - Elementary School! 5"
          }
        ]
      },
      {
        fieldTag: "u",
        marcTag: "246",
        ind1: "3",
        ind2: "0",
        content: nil,
        subfields: [
          {
            tag: "a",
            content: "English Language Arts: Books for Reading and Sharing - Elementary School! Gr. 1-2 (Teacher Set)."
          }
        ]
      },
      {
        fieldTag: "y",
        marcTag: "901",
        ind1: " ",
        ind2: " ",
        content: nil,
        subfields: [
          {
            tag: "a",
            content: "ed"
          },
          {
            tag: "b",
            content: "SEL"
          }
        ]
      },
      {
        fieldTag: "y",
        marcTag: "944",
        ind1: " ",
        ind2: " ",
        content: nil,
        subfields: [
          {
            tag: "a",
            content: "9781896580601 9781896580602 9781896580603"
          }
        ]
      },
      {
        fieldTag: "_",
        marcTag: nil,
        ind1: nil,
        ind2: nil,
        content: "00000nam  2200000 a 4500",
        subfields: nil
      }
    ]
  },
  {
    id: "#{BNUMBER2}",
    nyplSource: "sierra-nypl",
    nyplType: "bib",
    updatedDate: "2017-08-23T20:22:13-04:00",
    createdDate: "2017-08-23T14:46:46-04:00",
    deletedDate: nil,
    deleted: false,
    locations: [
      {
        code: "ed",
        name: "LSC Educator Collection"
      }
    ],
    suppressed: false,
    lang: {
      code: "eng",
      name: "English"
    },
    title: "Title 2",
    author: "",
    materialType: {
      code: "8",
      value: "TEACHER SET"
    },
    bibLevel: {
      code: "m",
      value: "MONOGRAPH"
    },
    publishYear: nil,
    catalogDate: "2017-08-23",
    country: {
      code: "xx ",
      name: "Unknown or undetermined"
    },
    normTitle: "books for reading and sharing elementary school",
    normAuthor: "",
    standardNumbers: [],
    controlNumber: "",
    fixedFields: {
      '24': {
        label: "Language",
        value: "eng",
        display: "English"
      },
      '25': {
        label: "Skip",
        value: "0",
        display: nil
      },
      '26': {
        label: "Location",
        value: "ed   ",
        display: "LSC Educator Collection"
      },
      '27': {
        label: "COPIES",
        value: "0",
        display: nil
      },
      '28': {
        label: "Cat. Date",
        value: "2017-08-23",
        display: nil
      },
      '29': {
        label: "Bib Level",
        value: "m",
        display: "MONOGRAPH"
      },
      '30': {
        label: "Material Type",
        value: "8",
        display: "TEACHER SET"
      },
      '31': {
        label: "Bib Code 3",
        value: "-",
        display: nil
      },
      '80': {
        label: "Record Type",
        value: "b",
        display: nil
      },
      '81': {
        label: "Record Number",
        value: "21323534",
        display: nil
      },
      '83': {
        label: "Created Date",
        value: "2017-08-23T14:46:46Z",
        display: nil
      },
      '84': {
        label: "Updated Date",
        value: "2017-08-23T20:22:13Z",
        display: nil
      },
      '85': {
        label: "No. of Revisions",
        value: "2",
        display: nil
      },
      '86': {
        label: "Agency",
        value: "1",
        display: nil
      },
      '89': {
        label: "Country",
        value: "xx ",
        display: "Unknown or undetermined"
      },
      '98': {
        label: "PDATE",
        value: "2017-08-23T20:20:00Z",
        display: nil
      },
      '107': {
        label: "MARC Type",
        value: " ",
        display: nil
      }
    },
    varFields: [
      {
        fieldTag: "d",
        marcTag: "655",
        ind1: " ",
        ind2: "7",
        content: nil,
        subfields: [
          {
            tag: "a",
            content: "Stories in rhyme."
          },
          {
            tag: "2",
            content: "lcgft"
          }
        ]
      },
      {
        fieldTag: "c",
        marcTag: "091",
        ind1: " ",
        ind2: " ",
        content: nil,
        subfields: [
          {
            tag: "a",
            content: "Teacher Set ELA A Books 4"
          }
        ]
      },
      {
        fieldTag: "d",
        marcTag: "650",
        ind1: " ",
        ind2: "1",
        content: nil,
        subfields: [
          {
            tag: "a",
            content: "Political activists."
          }
        ]
      },
      {
        fieldTag: "d",
        marcTag: "650",
        ind1: " ",
        ind2: "1",
        content: nil,
        subfields: [
          {
            tag: "a",
            content: "Race relations."
          }
        ]
      },
      {
        fieldTag: "d",
        marcTag: "690",
        ind1: "0",
        ind2: "7",
        content: nil,
        subfields: [
          {
            tag: "a",
            content: "English Language Arts."
          },
          {
            tag: "2",
            content: "local"
          }
        ]
      },
      {
        fieldTag: "n",
        marcTag: "500",
        ind1: " ",
        ind2: " ",
        content: nil,
        subfields: [
          {
            tag: "a",
            content: "2 copies of 10 titles."
          }
        ]
      },
      {
        fieldTag: "n",
        marcTag: "505",
        ind1: " ",
        ind2: " ",
        content: nil,
        subfields: [
          {
            tag: "a",
            content: "Anna carries water -- Monkey & Robot -- Mother Bruce -- The book with no pictures -- The day the crayons quit --
             The scraps book : notes from a colorful life -- Three bears in a boat -- Blizzard -- Bright Sky, Starry City -- Hula-Hoopin Queen."
          }
        ]
      },
      {
        fieldTag: "n",
        marcTag: "520",
        ind1: " ",
        ind2: " ",
        content: nil,
        subfields: [
          {
            tag: "a",
            content: "Topic Set (20 books) - This set of titles are great for reading aloud and sharing in the classroom - grades 1 and grades 2. 
            These titles were former selections from the NYC Department of Education NYC Reads 365 list."
          }
        ]
      },
      {
        fieldTag: "e",
        marcTag: "250",
        ind1: " ",
        ind2: " ",
        content: nil,
        subfields: [
          {
            tag: "a",
            content: "1st Hyperion Paperbacks ed."
          }
        ]
      },
      {
        fieldTag: "i",
        marcTag: "020",
        ind1: " ",
        ind2: " ",
        content: nil,
        subfields: [
          {
            tag: "a",
            content: "9781489813930"
          }
        ]
      },
      {
        fieldTag: "p",
        marcTag: "260",
        ind1: " ",
        ind2: " ",
        content: nil,
        subfields: [
          {
            tag: "a",
            content: "McHenry, Ill. :"
          },
          {
            tag: "b",
            content: "Follett Library Resources,"
          },
          {
            tag: "c",
            content: "2013."
          }
        ]
      },
      {
        fieldTag: "n",
        marcTag: "521",
        ind1: "2",
        ind2: " ",
        content: nil,
        subfields: [
          {
            tag: "a",
            content: "K-1."
          }
        ]
      },
      {
        fieldTag: "n",
        marcTag: "521",
        ind1: "2",
        ind2: " ",
        content: nil,
        subfields: [
          {
            tag: "a",
            content: "1-2."
          }
        ]
      },
      {
        fieldTag: "n",
        marcTag: "521",
        ind1: "8",
        ind2: " ",
        content: nil,
        subfields: [
          {
            tag: "a",
            content: "70L-500L"
          },
          {
            tag: "b",
            content: "Lexile"
          }
        ]
      },
      {
        fieldTag: "r",
        marcTag: "300",
        ind1: " ",
        ind2: " ",
        content: nil,
        subfields: [
          {
            tag: "a",
            content: "20 v."
          }
        ]
      },
      {
        fieldTag: "s",
        marcTag: "490",
        ind1: "0",
        ind2: " ",
        content: nil,
        subfields: [
          {
            tag: "a",
            content: "Teacher Sets: MyLibraryNYC Program"
          }
        ]
      },
      {
        fieldTag: "t",
        marcTag: "245",
        ind1: "0",
        ind2: "0",
        content: nil,
        subfields: [
          {
            tag: "a",
            content: "Books for Reading and Sharing - Elementary School! 6"
          }
        ]
      },
      {
        fieldTag: "u",
        marcTag: "246",
        ind1: "3",
        ind2: "0",
        content: nil,
        subfields: [
          {
            tag: "a",
            content: "English Language Arts: Books for Reading and Sharing - Elementary School! Gr. 1-2 (Teacher Set)."
          }
        ]
      },
      {
        fieldTag: "y",
        marcTag: "901",
        ind1: " ",
        ind2: " ",
        content: nil,
        subfields: [
          {
            tag: "a",
            content: "ed"
          },
          {
            tag: "b",
            content: "SEL"
          }
        ]
      },
      {
        fieldTag: "y",
        marcTag: "944",
        ind1: " ",
        ind2: " ",
        content: nil,
        subfields: [
          {
            tag: "a",
            content: "9781896580611 9781896580612 9781896580613"
          }
        ]
      },
      {
        fieldTag: "_",
        marcTag: nil,
        ind1: nil,
        ind2: nil,
        content: "00000nam  2200000 a 4500",
        subfields: nil
      }
    ]
  }
]

TEACHER_SET_WITH_TITLE_MISSING = [
  {
    id: "#{BNUMBER1}",
    nyplSource: "sierra-nypl",
    nyplType: "bib",
    updatedDate: "2017-08-23T20:22:13-04:00",
    createdDate: "2017-08-23T14:46:46-04:00",
    deletedDate: nil,
    deleted: false,
    locations: [
      {
        code: "ed",
        name: "LSC Educator Collection"
      }
    ],
    suppressed: false,
    lang: {
      code: "eng",
      name: "English"
    },
    title: nil,
    author: "",
    materialType: {
      code: "8",
      value: "TEACHER SET"
    },
    bibLevel: {
      code: "m",
      value: "MONOGRAPH"
    },
    publishYear: nil,
    catalogDate: "2017-08-23",
    country: {
      code: "xx ",
      name: "Unknown or undetermined"
    },
    normTitle: "books for reading and sharing elementary school",
    normAuthor: "",
    standardNumbers: [],
    controlNumber: "",
    fixedFields: {
      '24': {
        label: "Language",
        value: "eng",
        display: "English"
      },
      '25': {
        label: "Skip",
        value: "0",
        display: nil
      },
      '26': {
        label: "Location",
        value: "ed   ",
        display: "LSC Educator Collection"
      },
      '27': {
        label: "COPIES",
        value: "0",
        display: nil
      },
      '28': {
        label: "Cat. Date",
        value: "2017-08-23",
        display: nil
      },
      '29': {
        label: "Bib Level",
        value: "m",
        display: "MONOGRAPH"
      },
      '30': {
        label: "Material Type",
        value: "8",
        display: "TEACHER SET"
      },
      '31': {
        label: "Bib Code 3",
        value: "-",
        display: nil
      },
      '80': {
        label: "Record Type",
        value: "b",
        display: nil
      },
      '81': {
        label: "Record Number",
        value: "21323534",
        display: nil
      },
      '83': {
        label: "Created Date",
        value: "2017-08-23T14:46:46Z",
        display: nil
      },
      '84': {
        label: "Updated Date",
        value: "2017-08-23T20:22:13Z",
        display: nil
      },
      '85': {
        label: "No. of Revisions",
        value: "2",
        display: nil
      },
      '86': {
        label: "Agency",
        value: "1",
        display: nil
      },
      '89': {
        label: "Country",
        value: "xx ",
        display: "Unknown or undetermined"
      },
      '98': {
        label: "PDATE",
        value: "2017-08-23T20:20:00Z",
        display: nil
      },
      '107': {
        label: "MARC Type",
        value: " ",
        display: nil
      }
    },
    varFields: [
      {
        fieldTag: "c",
        marcTag: "091",
        ind1: " ",
        ind2: " ",
        content: nil,
        subfields: [
          {
            tag: "a",
            content: "Teacher Set ELA A Books 4"
          }
        ]
      },
      {
        fieldTag: "d",
        marcTag: "650",
        ind1: " ",
        ind2: "1",
        content: nil,
        subfields: [
          {
            tag: "a",
            content: "Political activists."
          }
        ]
      },
      {
        fieldTag: "d",
        marcTag: "650",
        ind1: " ",
        ind2: "1",
        content: nil,
        subfields: [
          {
            tag: "a",
            content: "Race relations."
          }
        ]
      },
      {
        fieldTag: "d",
        marcTag: "690",
        ind1: "0",
        ind2: "7",
        content: nil,
        subfields: [
          {
            tag: "a",
            content: "English Language Arts."
          },
          {
            tag: "2",
            content: "local"
          }
        ]
      },
      {
        fieldTag: "n",
        marcTag: "500",
        ind1: " ",
        ind2: " ",
        content: nil,
        subfields: [
          {
            tag: "a",
            content: "2 copies of 10 titles."
          }
        ]
      },
      {
        fieldTag: "n",
        marcTag: "505",
        ind1: " ",
        ind2: " ",
        content: nil,
        subfields: [
          {
            tag: "a",
            content: "Anna carries water -- Monkey & Robot -- Mother Bruce -- The book with no pictures -- The day the crayons quit -- 
            The scraps book : notes from a colorful life -- Three bears in a boat -- Blizzard -- Bright Sky, Starry City -- Hula-Hoopin Queen."
          }
        ]
      },
      {
        fieldTag: "n",
        marcTag: "520",
        ind1: " ",
        ind2: " ",
        content: nil,
        subfields: [
          {
            tag: "a",
            content: "Topic Set (20 books) - This set of titles are great for reading aloud and sharing in the classroom - grades 1 and grades 2.
            These titles were former selections from the NYC Department of Education NYC Reads 365 list."
          }
        ]
      },
      {
        fieldTag: "e",
        marcTag: "250",
        ind1: " ",
        ind2: " ",
        content: nil,
        subfields: [
          {
            tag: "a",
            content: "1st Hyperion Paperbacks ed."
          }
        ]
      },
      {
        fieldTag: "i",
        marcTag: "020",
        ind1: " ",
        ind2: " ",
        content: nil,
        subfields: [
          {
            tag: "a",
            content: "9781489813930"
          }
        ]
      },
      {
        fieldTag: "p",
        marcTag: "260",
        ind1: " ",
        ind2: " ",
        content: nil,
        subfields: [
          {
            tag: "a",
            content: "McHenry, Ill. :"
          },
          {
            tag: "b",
            content: "Follett Library Resources,"
          },
          {
            tag: "c",
            content: "2013."
          }
        ]
      },
      {
        fieldTag: "n",
        marcTag: "521",
        ind1: "2",
        ind2: " ",
        content: nil,
        subfields: [
          {
            tag: "a",
            content: "K-1."
          }
        ]
      },
      {
        fieldTag: "n",
        marcTag: "521",
        ind1: "2",
        ind2: " ",
        content: nil,
        subfields: [
          {
            tag: "a",
            content: "1-2."
          }
        ]
      },
      {
        fieldTag: "n",
        marcTag: "521",
        ind1: "8",
        ind2: " ",
        content: nil,
        subfields: [
          {
            tag: "a",
            content: "70L-500L"
          },
          {
            tag: "b",
            content: "Lexile"
          }
        ]
      },
      {
        fieldTag: "r",
        marcTag: "300",
        ind1: " ",
        ind2: " ",
        content: nil,
        subfields: [
          {
            tag: "a",
            content: "20 v."
          }
        ]
      },
      {
        fieldTag: "s",
        marcTag: "490",
        ind1: "0",
        ind2: " ",
        content: nil,
        subfields: [
          {
            tag: "a",
            content: "Teacher Sets: MyLibraryNYC Program"
          }
        ]
      },
      {
        fieldTag: "t",
        marcTag: "245",
        ind1: "0",
        ind2: "0",
        content: nil,
        subfields: [
          {
            tag: "a",
            content: "Books for Reading and Sharing - Elementary School! 7"
          }
        ]
      },
      {
        fieldTag: "u",
        marcTag: "246",
        ind1: "3",
        ind2: "0",
        content: nil,
        subfields: [
          {
            tag: "a",
            content: "English Language Arts: Books for Reading and Sharing - Elementary School! Gr. 1-2 (Teacher Set)."
          }
        ]
      },
      {
        fieldTag: "y",
        marcTag: "901",
        ind1: " ",
        ind2: " ",
        content: nil,
        subfields: [
          {
            tag: "a",
            content: "ed"
          },
          {
            tag: "b",
            content: "SEL"
          }
        ]
      },
      {
        fieldTag: "y",
        marcTag: "944",
        ind1: " ",
        ind2: " ",
        content: nil,
        subfields: [
          {
            tag: "a",
            content: "9781896580601  9781896580602  9781896580603"
          }
        ]
      },
      {
        fieldTag: "_",
        marcTag: nil,
        ind1: nil,
        ind2: nil,
        content: "00000nam  2200000 a 4500",
        subfields: nil
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
    id: "0",
    title: "Example for non-existant bnumber"
  },
  {
      id: "#{BNUMBER1}",
      nyplSource: "sierra-nypl",
      nyplType: "bib",
      updatedDate: "2017-08-25T06:32:01-04:00",
      createdDate: nil,
      deletedDate: "2012-06-08",
      deleted: true,
      locations: [],
      suppressed: nil,
      lang: nil,
      title: nil,
      author: nil,
      materialType: nil,
      bibLevel: nil,
      publishYear: nil,
      catalogDate: nil,
      country: nil,
      normTitle: nil,
      normAuthor: nil,
      standardNumbers: [],
      controlNumber: "",
      fixedFields: {},
      varFields: [],
      count: 1,
      totalCount: 0,
      statusCode: 200,
      debugInfo: []
    }
]

SIERRA_USER = {"data" =>
  [{"barCodes" => ["27777023005746"],
    "id" => '7899158',
    "title" => 'title',
    "updatedDate" => "2020-07-28T23:24:45+00:00",
    "createdDate" => "2020-07-28T23:24:45+00:00",
    "deleted" => false,
    "suppressed" => false,
    "names" => ["TESTER, QA"],
    "barcodes" => ["27777023005746"],
    "emails" => ["qa-tester-8132@rssnyc.org"],
    "patronType" => 151,
    "patronCodes" => {"pcode1"=>"-", "pcode2"=>"-", "pcode3"=>2, "pcode4"=>585},
    "homeLibraryCode" => "mm",
    "message" => {"code"=>"-", "accountMessages"=>["qa-tester-8132@rssnyc.org"]},
    "blockInfo" => {"code"=>"-"},
    "addresses" => [{"lines"=>["443 WEST 135 STREET", "MANHATTAN, NY 10031"], "type"=>"a"}],
    "phones" => [{"number"=>"212-690-6800", "type"=>"t"}, {"number"=>"A. Philip Randolph Campus High School", "type"=>"o"}],
    "moneyOwed" => 0.0,
    "fixedFields" =>
     {"44" => {"label"=>"E-Communications", "value"=>"-", "display"=>"English"},
      "45" => {"label"=>"Education Level", "value"=>"-"},
      "46" => {"label"=>"Home Region", "value"=>"2"},
      "47" => {"label"=>"Patron Type", "value"=>"151"},
      "48" => {"label"=>"Total Checkouts", "value"=>"0"},
      "49" => {"label"=>"Total Renewals", "value"=>"0"},
      "50" => {"label"=>"Current Checkouts", "value"=>"0"},
      "53" => {"label"=>"Home Library", "value"=>"mm   "},
      "54" => {"label"=>"Patron Message", "value"=>"-"},
      "55" => {"label"=>"Highest Overdues", "value"=>"0"},
      "56" => {"label"=>"Manual Block", "value"=>"-"},
      "80" => {"label"=>"Record Type", "value"=>"p"},
      "81" => {"label"=>"Record Number", "value"=>"7899158"},
      "83" => {"label"=>"Created Date", "value"=>"2020-07-28T23:24:45Z"},
      "84" => {"label"=>"Updated Date", "value"=>"2020-07-28T23:24:45Z"},
      "85" => {"label"=>"No. of Revisions", "value"=>"1"},
      "86" => {"label"=>"Agency", "value"=>"1"},
      "95" => {"label"=>"Claims Returned", "value"=>"0"},
      "96" => {"label"=>"Money Owed", "value"=>0},
      "98" => {"label"=>"PDATE", "value"=>"2020-07-28T23:24:45Z"},
      "99" => {"label"=>"FIRM", "value"=>"     "},
      "102" => {"label"=>"Current Item A", "value"=>"0"},
      "103" => {"label"=>"Current Item B", "value"=>"0"},
      "104" => {"label"=>"PIUSE", "value"=>"0"},
      "105" => {"label"=>"Overdue Penalty", "value"=>"0"},
      "122" => {"label"=>"ILL Request", "value"=>"0"},
      "123" => {"label"=>"Debit Balance", "value"=>0},
      "124" => {"label"=>"Current Item C", "value"=>"0"},
      "125" => {"label"=>"Current Item D", "value"=>"0"},
      "126" => {"label"=>"School Code", "value"=>"585"},
      "158" => {"label"=>"Patron Agency", "value"=>"0"},
      "263" => {"label"=>"Preferred Language", "value"=>"eng"},
      "268" => {"label"=>"Notice Preference", "value"=>"-"},
      "269" => {"label"=>"Registrations on Record", "value"=>"0"},
      "270" => {"label"=>"Total Registrations", "value"=>"0"},
      "271" => {"label"=>"Total Programs Attended", "value"=>"0"},
      "297" => {"label"=>"Waitlists on Record", "value"=>"0"}},
    "varFields" =>
     [{"fieldTag"=>"=", "content"=>"$6$WuFQmJQ68AA65p/b$EgG1Jiq1yUGYqpryzsQu6EtAJczrNzWfn/IUv5w.o0xxmccep0t1/Rm5aGESFSpOSWqNoPXItH6jnYZlqfTF3."},
      {"fieldTag"=>"b", "content"=>"27777023005746"},
      {"fieldTag"=>"o", "content"=>"A. Philip Randolph Campus High School"},
      {"fieldTag"=>"z", "content"=>"qa-tester-8132@rssnyc.org"},
      {"fieldTag"=>"a", "content"=>"443 WEST 135 STREET$MANHATTAN, NY 10031"},
      {"fieldTag"=>"n", "content"=>"TESTER, QA"},
      {"fieldTag"=>"d", "marcTag"=>"650", "ind1"=>"", "ind2"=>"0", "content"=>"null", "subfields"=>[{"tag"=>"a", "content"=>"Elections."}]},
      {"fieldTag"=>"r", "marcTag"=>"300", "content"=>"", "subfields"=>[{"tag"=>"a", "content"=>"physical desc"}]},
      {"fieldTag"=>"n", "marcTag"=>"500", "ind1"=>" ", "ind2"=>" ", "content"=>"null", "subfields"=> [{"tag"=>"a", "content"=> "Learning set"}]},
      {"fieldTag"=>"n", "marcTag"=>"526", "ind1"=>" ", "ind2"=>" ", "content"=>"null", "subfields"=> [{"tag"=>"a", "content"=> "Topic Set"}]},
      {"fieldTag"=>"n", "marcTag"=>"521", "ind1"=>" ", "ind2"=>" ", "content"=>"null", "subfields"=> [{"tag"=>"a", "content"=> "3-8"}]},
      {"fieldTag"=>"t", "content"=>"212-690-6800"}]}],
               "count" => 1,
               "statusCode" => 200}


class ActionController::TestCase
  include Devise::Test::ControllerHelpers
end


class ActiveSupport::TestCase
  setup :mock_get_oauth_token_request, :mock_send_request_to_patron_creator_service, :send_request_to_bibs_microservice,
        :mock_send_request_to_items_microservice, :mock_send_request_to_s3_adapter, :mock_send_request_to_elastic_search_service,
        :mock_delete_request_from_elastic_search_service, :mock_security_credentials, :mock_aws_request, :mock_es_doc, :mock_delete_es_doc,
        :mock_send_request_to_bib_service, :mock_items_response_with7899158, :mock_bib_response_with123, :mock_item_response_with_empty_bib, 
        :mock_google_address
        

  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  # Add more helper methods to be used by all tests here...

  # Return a string with 14 random digits, suitable for a barcode.
  def self.generate_barcode
    barcode = Array.new(14) { rand(10) }
    barcode = barcode.join
    return barcode
  end


  # generate_email returns a string with 8 random characters concatenated with the current timestamp
  # and domain schools.nyc.gov
  def self.generate_email
    return "#{('a'..'z').to_a.sample(8).join}#{Time.now.to_i}@schools.nyc.gov"
  end


  # generate_email returns a string with 8 random characters concatenated with the current timestamp
  # and domain gmail.com
  def self.generate_email_without_valid_domain
    return "#{('a'..'z').to_a.sample(8).join}#{Time.now.to_i}@gmail.com"
  end


  # mock_get_oauth_token_request mocks an https request to 'https://isso.nypl.org/oauth/token'
  # and returns a JSON object with the key access_token
  def mock_get_oauth_token_request
    stub_request(:post, 'https://isso.nypl.org/oauth/token')
      .to_return(status: 200, body: { 'access_token' => 'testoken' }.to_json)
  end


  # Mocks an https request to 'https://qa-platform.nypl.org/api/v0.1/patrons?barcode=' .
  # Accepts a barcode, and the Sierra response status to simulate.
  # Returns the passed in response status code, and an appropriate response body to match it.
  def mock_check_barcode_request(barcode, status_code)
    if status_code == '404'
      stub_request(:get, "#{ENV.fetch('PATRON_MICROSERVICE_URL_V01', nil)}?barcode=" + barcode)
        .to_return(status: 404, body: {
          "message" => "Failed to retrieve patron record by barcode",
          "statusCode" => 404
        }
        .to_json, headers: { 'Content-Type' => 'application/json' })
      return
    end

    if status_code == '409'
      stub_request(:get, "#{ENV.fetch('PATRON_MICROSERVICE_URL_V01', nil)}?barcode=" + barcode)
        .to_return(status: 409, body: {
          "message" => "Multiple patron records found",
          "statusCode" => 409
        }
        .to_json, headers: { 'Content-Type' => 'application/json' })
      return
    end

    if status_code == '500'
      stub_request(:get, "#{ENV.fetch('PATRON_MICROSERVICE_URL_V01', nil)}?barcode=" + barcode)
        .to_return(status: 500, body: {
          "message" => "Server error",
          "statusCode" => 500
        }
        .to_json, headers: { 'Content-Type' => 'application/json' })
      return
    end

    # return a successful 200 "single unique user found" response
    stub_request(:get, "#{ENV.fetch('PATRON_MICROSERVICE_URL_V01', nil)}?barcode=" + barcode)
      .to_return(status: 200,
                 body: SIERRA_USER.to_json,
                 headers: { 'Content-Type' => 'application/json' })
  end


  # mock_check_email_request takes in a parameter of e-mail and mocks an https
  # request to 'https://qa-platform.nypl.org/api/v0.1/patrons?email=' and returns a
  # 404 statusCode if the e-mail hasn't been created in Sierra.
  # TODO: Need to add 200 if the e-mail has been created
  def mock_check_email_request(email)
    stub_request(:get, "#{ENV.fetch('PATRON_MICROSERVICE_URL_V01', nil)}?email=" + email)
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
    stub_request(:post, ENV.fetch('PATRON_MICROSERVICE_URL_V02', nil))
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

  def mock_send_request_to_bib_service
    stub_request(:get, "https://platform.nypl.org/api/v0.1/bibs?id=998&nyplSource=sierra-nypl").
      with(headers: {
        'content-Type' => 'application/json',
        'Authorization' => 'Bearer testoken'
      }).to_return(status: 200, body: "", headers: {})
  end
  # mock_get_data_from_aws_s3_adapter
  # to 'https://my-library-nyc-config.s3.amazonaws.com/test/feature_flag.yml' and returns a
  def mock_send_request_to_s3_adapter
    stub_request(:get, "https://my-library-nyc-config.s3.amazonaws.com/test/feature_flag.yml")
      .to_return(
        { status: 200, body: { 'status' => 'success' }.to_json, headers: {} },
        { status: 500, body: { 'status' => 'failure' }.to_json, headers: {} }
      )
  end

  def mock_send_request_to_elastic_search_service
    stub_request(:put, "https://vpc-mylibrarynyc-development-yvrqkaicwhwb5tiz3n365a3xza.us-east-1.es.amazonaws.com/teacherset/teacherset/614468850?op_type=create")
      .to_return(
        {
          status: 200,
          body: { "id" => 614468853, "title" => "title", "bnumber" => "b998" }.to_json,
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

  def mock_delete_request_from_elastic_search_service
    stub_request(:delete, "https://vpc-mylibrarynyc-development-yvrqkaicwhwb5tiz3n365a3xza.us-east-1.es.amazonaws.com/teacherset/teacherset/614468850?op_type=delete")
      .to_return(
        {
          status: 200,
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
      stub_request(:get, "#{ENV.fetch('BIBS_MICROSERVICE_URL_V01', nil)}?standardNumber=#{ 9781896580601 + x }").
        with(
          headers: {
            'Authorization' => 'Bearer testoken',
            'Content-Type' => 'application/json'
          }).to_return(status: 200, body: MODIFIED_BOOK_JSON_FOR_ISBN_9782917623268, headers: {})
    end
    stub_request(:get, "#{ENV.fetch('BIBS_MICROSERVICE_URL_V01', nil)}?standardNumber=123456789").
      with(
        headers: {
          'Authorization' => 'Bearer testoken',
          'Content-Type' => 'application/json'
        }).to_return(status: 200, body: JSON_FOR_BOOK_WITH_ISBN_AND_TITLE_TOO_LONG, headers: {})
  end

  # send_request_to_items_microservice sends an https request
  # to "https://https://qa-platform.nypl.org/api/v0.1/items
  # status of success if Sierra API finds the bib record.
  def mock_send_request_to_items_microservice
    items_query_params = "?bibId=998&limit=25&offset=0"
    stub_request(:get, "#{ENV.fetch('ITEMS_MICROSERVICE_URL_V01', nil)}" + items_query_params).
      with(
        headers: {
        'Authorization' => 'Bearer testoken',
        'Content-Type' => 'application/json'
        }).to_return(status: 200, body: ITEM_JSON_REQUEST_BODY, headers: {})

    items_query_params = "?bibId=999&limit=25&offset=0"
    stub_request(:get, "#{ENV.fetch('ITEMS_MICROSERVICE_URL_V01', nil)}" + items_query_params).
      with(
        headers: {
        'Authorization' => 'Bearer testoken',
        'Content-Type' => 'application/json'
        }).to_return(status: 200, body: ITEM_JSON_REQUEST_BODY, headers: {})
  end

  def mock_items_response_with7899158
    stub_request(:get, "https://qa-platform.nypl.org/api/v0.1/items?bibId=7899158&limit=25&offset=0").
      with(
        headers: {
        'Accept' => '*/*',
        'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
        'Authorization' => 'Bearer testoken',
        'Content-Type' => 'application/json',
        'User-Agent' => 'Ruby'
        }).to_return(status: 200, body: ITEM_JSON_REQUEST_BODY, headers: {})
  end


  def mock_bib_response_with123
    stub_request(:get, "https://platform.nypl.org/api/v0.1/bibs?id=123&nyplSource=sierra-nypl").
      with(
        headers: {
        'Accept' => '*/*',
        'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
        'Authorization' => 'Bearer testoken',
        'Content-Type' => 'application/json',
        'User-Agent' => 'Ruby'
        }).to_return(status: 200, body: "", headers: {})
  end

  def mock_security_credentials
    stub_request(:get, "http://169.254.169.254/latest/meta-data/iam/security-credentials/").with(
      headers: {
        'Accept' => '*/*',
        'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
        'User-Agent' => 'aws-sdk-ruby3/3.68.1'
        }).to_return(status: 200, body: "", headers: {})
  end


  def mock_aws_request
    WebMock.stub_request(:post, "https://kms.us-east-1.amazonaws.com/").to_return(:status => 200, :body => "", :headers => {})
  end


  def mock_es_doc
    stub_request(:get, "https://vpc-mylibrarynyc-development-yvrqkaicwhwb5tiz3n365a3xza.us-east-1.es.amazonaws.com/teacherset/_search").
      with(
        body: "{\"query\":{\"bool\":{\"must\":[]}},\"from\":0,\"size\":20,\"sort\":[{\"_score\":\"desc\",\"availability.raw\":\"asc\",
        \"created_at\":\"desc\",\"_id\":\"asc\"}],\"aggs\":{\"language\":{\"terms\":{\"field\":\"primary_language\",\"size\":100,
        \"order\":{\"_key\":\"asc\"}}},\"set type\":{\"terms\":{\"field\":\"set_type\",\"size\":10,\"order\":{\"_key\":\"asc\"}}},
        \"availability\":{\"terms\":{\"field\":\"availability.raw\",\"size\":10,\"order\":{\"_key\":\"asc\"}}},
        \"area of study\":{\"terms\":{\"field\":\"area_of_study\",\"size\":100,\"order\":{\"_key\":\"asc\"}}},
        \"subjects\":{\"nested\":{\"path\":\"subjects\"},\"aggregations\":{\"subjects\":{\"composite\":{\"size\":3000,
        \"sources\":[{\"id\":{\"terms\":{\"field\":\"subjects.id\"}}},{\"title\":{\"terms\":{\"field\":\"subjects.title\"}}}]}}}}}}",
        headers: {
        'Accept' => '*/*',
        'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
        'Content-Type' => 'application/json',
        'User-Agent' => 'Faraday v1.0.1'
        }).
      to_return(status: 200, body: "", headers: {})
  end

  def mock_delete_es_doc
    stub_request(:delete, "https://vpc-mylibrarynyc-development-yvrqkaicwhwb5tiz3n365a3xza.us-east-1.es.amazonaws.com/teacherset/teacherset/614468851").
      with(
        headers: {
        'Accept' => '*/*',
        'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
        'Content-Type' => 'application/json',
        'User-Agent' => 'Faraday v1.0.1'
        }).
      to_return(status: 200, body: "", headers: {})
  end

  def mock_item_response_with_empty_bib
    stub_request(:get, "https://qa-platform.nypl.org/api/v0.1/items?bibId=&limit=25&offset=0").
      with(
        headers: {
        'Accept' => '*/*',
        'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
        'Authorization' => 'Bearer testoken',
        'Content-Type' => 'application/json',
        'User-Agent' => 'Ruby'
        }).
      to_return(status: 200, body: "", headers: {})
  end


  def mock_google_address
    stub_request(:get, "http://169.254.169.254/").
      with(
        headers: {
        'Accept' => '*/*',
        'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
        'Metadata-Flavor' => 'Google',
        'User-Agent' => 'Faraday v0.17.4'
        }).
      to_return(status: 200, body: "", headers: {})
  end

end

begin
  puts "Starting test run..."

  puts "Starting DatabaseCleaner..."
  DatabaseCleaner.allow_remote_database_url = true
  DatabaseCleaner.strategy = :truncation
  DatabaseCleaner.start
ensure
  puts "Cleaning up with DatabaseCleaner..."
  DatabaseCleaner.clean
end
