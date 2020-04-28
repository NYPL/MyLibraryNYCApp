echo "Enter elastic search url $url"
	curl -X POST "$index_name"

	curl -XGET "https://vpc-mylibrarynyc-development-yvrqkaicwhwb5tiz3n365a3xza.us-east-1.es.amazonaws.com/techerset_index/_search"


 curl -XDELETE "https://vpc-mylibrarynyc-development-yvrqkaicwhwb5tiz3n365a3xza.us-east-1.es.amazonaws.com/techerset_index"



analyzer(
    'plain_ascii',
    tokenizer='standard',
    filter=['standard', 'lowercase', 'stop', 'asciifolding']
)



curl -XDELETE "https://vpc-mylibrarynyc-development-yvrqkaicwhwb5tiz3n365a3xza.us-east-1.es.amazonaws.com/techerset_index"

curl -XPUT "https://vpc-mylibrarynyc-development-yvrqkaicwhwb5tiz3n365a3xza.us-east-1.es.amazonaws.com/techerset_index?" -H 'Content-Type: application/json' -d '
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
    "teacher_set" :{
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
        body = {title: ts.title, description: ts.description, contents: ts.contents, 
          id: ts.id.to_i, details_url: ts.details_url, grade_end: ts.grade_end, 
          grade_begin: ts.grade_begin, availability: availability, total_copies: ts.total_copies,
          call_number: ts.call_number, language: ts.language, physical_description: ts.physical_description,
          primary_language: ts.primary_language, created_at: created_at, updated_at: updated_at,
          available_copies: ts.available_copies, bnumber: ts.bnumber, set_type: ts.set_type, area_of_study: ts.area_of_study }
        ElasticSearch.new.create_document(ts.id, body)
        puts "updating elastic search"
      rescue Elasticsearch::Transport::Transport::Errors::Conflict => e
         puts "Error in elastic search"
        arr << ts.id
      end
      arr
    end
  end