ENV['RAILS_ENV'] = 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'webmock/test_unit'
require 'factories/user_factory'
require 'factories/school_factory'
require 'factories/book_factory'
require 'factories/teacher_set_factory'

include WebMock::API

WebMock.disable_net_connect!(allow_localhost: true)

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

class ActionController::TestCase
  include Devise::TestHelpers
end

class ActiveSupport::TestCase
  setup :mock_get_oauth_token_request, :mock_send_request_to_patron_creator_service, :send_request_to_bibs_microservice

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
  # request to 'https://dev-platform.nypl.org/api/v0.1/patrons?email=' and returns a
  # 404 statusCode if the e-mail hasn't been created in Sierra.
  # TODO: Need to add 200 if the e-mail has been created
  def mock_check_email_request(email)
    stub_request(:get, 'https://dev-platform.nypl.org/api/v0.1/patrons?email=' +
    email)
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
  # to 'https://dev-platform.nypl.org/api/v0.2/patrons' and returns a
  # status of success if Sierra API created a patron record.
  def mock_send_request_to_patron_creator_service
    stub_request(:post, 'https://dev-platform.nypl.org/api/v0.2/patrons')
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
  # to "https://platform.nypl.org/api/v0.1/bibs?standardNumber=9781896580601" and returns a
  # status of success if Sierra API finds the bib record.
  def send_request_to_bibs_microservice
    20.times do |x|
      stub_request(:get, "https://platform.nypl.org/api/v0.1/bibs?standardNumber=#{ 9781896580601 + x }").
        with(
          headers: {
      	  'Authorization'=>'Bearer testoken',
      	  'Content-Type'=>'application/json'
          }).to_return(status: 200, body: MODIFIED_BOOK_JSON_FOR_ISBN_9782917623268, headers: {}
      )
    end
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
