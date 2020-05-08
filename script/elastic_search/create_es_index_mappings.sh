curl -XDELETE "https://vpc-mylibrarynyc-development-yvrqkaicwhwb5tiz3n365a3xza.us-east-1.es.amazonaws.com/teacherset"

curl -XPUT "https://vpc-mylibrarynyc-development-yvrqkaicwhwb5tiz3n365a3xza.us-east-1.es.amazonaws.com/teacherset?" -H 'Content-Type: application/json' -d '
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








def create_teacherset_document_in_es
  TeacherSet.find_each do |ts|
    arr = []
    created_at = ts.created_at.present? ? ts.created_at.strftime("%Y-%m-%dT%H:%M:%S%z") : nil
    updated_at = ts.updated_at.present? ? ts.updated_at.strftime("%Y-%m-%dT%H:%M:%S%z") : nil
    availability = ts.availability.present? ? ts.availability.downcase : nil
    
    begin
      subjects_arr = []
      if ts.subjects.present?
        ts.subjects.uniq.each do |subject|
          subjects_hash = {}
          s_created_at = subject.created_at.present? ? subject.created_at.strftime("%Y-%m-%dT%H:%M:%S%z") : nil
          s_updated_at = subject.updated_at.present? ? subject.updated_at.strftime("%Y-%m-%dT%H:%M:%S%z") : nil
          subjects_hash[:id] = subject.id
          subjects_hash[:title] = subject.title
          subjects_hash[:created_at] = s_created_at
          subjects_hash[:updated_at] = s_updated_at
          subjects_arr << subjects_hash
        end
      end

      body = {title: ts.title, description: ts.description, contents: ts.contents, 
        id: ts.id.to_i, details_url: ts.details_url, grade_end: ts.grade_end, 
        grade_begin: ts.grade_begin, availability: availability, total_copies: ts.total_copies,
        call_number: ts.call_number, language: ts.language, physical_description: ts.physical_description,
        primary_language: ts.primary_language, created_at: created_at, updated_at: updated_at,
        available_copies: ts.available_copies, bnumber: ts.bnumber, set_type: ts.set_type, 
        area_of_study: ts.area_of_study, subjects: subjects_arr}

      ElasticSearch.new.create_document(ts.id, body)
      puts "updating elastic search"
    rescue Elasticsearch::Transport::Transport::Errors::Conflict => e
       puts "Error in elastic search"
      arr << ts.id
    end
    arr
  end
end