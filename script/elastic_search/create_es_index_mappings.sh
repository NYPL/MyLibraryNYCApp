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
            "type": "keyword"
          }
        }
      },
      "total_copies": {
        "type": "long"
      },
      "call_number": {
        "type": "text",
        "fields": {
          "keyword": {
            "type": "keyword"
          }
        }
      },
      "language": {
        "type": "text",
        "fields": {
          "keyword": {
            "type": "keyword"
          }
        }
      },
      "physical_description": {
        "type": "text",
        "fields": {
          "keyword": {
            "type": "keyword"
          }
        }
      },
      "primary_language": {
        "type": "text",
        "fielddata": true
      },
      "available_copies": {
        "type": "long"
      },
      "bnumber": {
        "type": "text",
        "fields": {
          "keyword": {
            "type": "keyword"
          }
        }
      },
      "set_type": {
        "type": "text",
        "fielddata": true
      },
      "area_of_study": {
        "type": "text",
        "fielddata": true
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
        "type": "nested",
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