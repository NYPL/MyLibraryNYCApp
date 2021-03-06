# Create elastic search mappings and index.
echo "Enter elastic search URL"
read es_url

curl -XPUT "$es_url/teacherset?" -H 'Content-Type: application/json' -d '
{
  "settings": {
    "analysis": {
      "analyzer": {
        "ts_analyzer": {
          "tokenizer" : "standard",
          "filter": ["standard", "lowercase", "stop", "asciifolding"]
        }
      }
    }
  },
  "mappings": {
    "teacherset" :{
       "properties": {
          "title": {
            "type": "text",
            "fields": {
              "keyword": {
              "type": "keyword"
              }
            },
            "analyzer": "ts_analyzer"
          },
          "description": {
            "type": "text",
            "fields": {
              "keyword": {
              "type": "keyword"
              }
            },
            "analyzer": "ts_analyzer"
          },
          "contents": {
            "type": "text",
            "fields": {
              "keyword": {
              "type": "keyword"
              }
            },
            "analyzer": "ts_analyzer"
            },
            "grade_begin": {
              "type": "integer"
            },
           "grade_end": {
              "type": "integer"
            },
           "id": {
              "type": "long"
            },
            "details_url": {
              "type": "keyword"
            },
             "availability": {
              "type": "text",
              "fields": {
                "raw": { 
                  "type":  "keyword"
                }
              }
            },
            "total_copies": {
              "type": "keyword"
            },
            "call_number":{
              "type": "keyword"
            },
            "language": {
              "type": "keyword"
            },
            "physical_description":{
              "type": "keyword"
            },
            "primary_language": {
              "type": "keyword"
            },
            "available_copies": {
              "type": "integer"
            },
            "bnumber": {
              "type": "keyword"
            },
             "set_type":{
              "type": "keyword"
            },
            "area_of_study": {
              "type": "keyword"
            },
            "created_at": {
              "type": "date",
              "format": "date_time_no_millis"
            },
            "updated_at": {
              "type": "date",
              "format": "date_time_no_millis"
            },
            "subjects": {
              "type": "nested",
              "properties": {
                "id": {
                  "type": "integer"
                },
                "title": {
                  "type": "text",
                  "fields": {
                    "keyword": {
                    "type": "keyword"
                    }
                  }
                },
                "created_at": {
                  "type": "date",
                  "format": "date_time_no_millis"
                },
                "updated_at": {
                  "type": "date",
                  "format": "date_time_no_millis"
                }
              }
          }
      }
    }
  }
}'