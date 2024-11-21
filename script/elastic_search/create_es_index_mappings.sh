# Create elastic search mappings and index.
echo "Enter elastic search URL"
read es_url

curl -XPUT "$es_url/teacherset?" -H 'Content-Type: application/json' -d '
{
  "settings": {
    "analysis": {
      "analyzer": {
        "ts_analyzer": {
          "tokenizer": "standard",
          "filter": ["lowercase", "stop", "asciifolding"]
        }
      }
    }
  },
  "mappings": {
    "properties": {
      "title": {
        "type": "text",
        "fields": {
          "keyword": {
            "type": "keyword"
          }
        },
        "analyzer": "default"
      },
      "description": {
        "type": "text",
        "fields": {
          "keyword": {
            "type": "keyword"
          }
        },
        "analyzer": "default"
      },
      "contents": {
        "type": "text",
        "fields": {
          "keyword": {
            "type": "keyword"
          }
        },
        "analyzer": "default"
      },
      "grade_begin": {
        "type": "long"
      },
      "grade_end": {
        "type": "long"
      },
      "id": {
        "type": "long"
      },
      "details_url": {
        "type": "text"
      },
      "availability": {
        "type": "text",
        "fields": {
          "raw": {
            "type": "text"
          }
        }
      },
      "total_copies": {
        "type": "long"
      },
      "call_number": {
        "type": "text"
      },
      "language": {
        "type": "text"
      },
      "physical_description": {
        "type": "text"
      },
      "primary_language": {
        "type": "text"
      },
      "available_copies": {
        "type": "long"
      },
      "bnumber": {
        "type": "text"
      },
      "set_type": {
        "type": "text"
      },
      "area_of_study": {
        "type": "text"
      },
      "created_at": {
        "type": "date",
        "format": "strict_date_optional_time||epoch_millis"
      },
      "updated_at": {
        "type": "date",
        "format": "strict_date_optional_time||epoch_millis"
      },
      "subjects": {
        "type": "object",
        "properties": {
          "id": {
            "type": "long"
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
            "format": "strict_date_optional_time||epoch_millis"
          },
          "updated_at": {
            "type": "date",
            "format": "strict_date_optional_time||epoch_millis"
          }
        }
      }
    }
  }
}'