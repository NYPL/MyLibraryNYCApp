namespace :elasticsearch do
  desc 'Create Elasticsearch mappings and index for teachersets'
  task create_teacherset_index: :environment do
    require 'elasticsearch'

    body = {
      settings: {
        analysis: {
          analyzer: {
            ts_analyzer: {
              tokenizer: 'standard',
              filter: %w[lowercase stop asciifolding]
            }
          }
        }
      },
      mappings: {
        properties: {
          title: {
            type: 'text',
            fields: {
              keyword: {
                type: 'keyword'
              }
            },
            analyzer: 'ts_analyzer'
          },
          description: {
            type: 'text',
            fields: {
              keyword: {
                type: 'keyword'
              }
            },
            analyzer: 'ts_analyzer'
          },
          contents: {
            type: 'text',
            fields: {
              keyword: {
                type: 'keyword'
              }
            },
            analyzer: 'ts_analyzer'
          },
          grade_begin: { type: 'long' },
          grade_end: { type: 'long' },
          id: { type: 'long' },
          details_url: { type: 'text' },
          availability: {
            type: 'text',
            fields: {
              raw: { type: 'keyword' }
            }
          },
          total_copies: { type: 'long' },
          call_number: {
            type: 'text',
            fields: {
              keyword: { type: 'keyword' }
            }
          },
          language: {
            type: 'text',
            fields: {
              keyword: { type: 'keyword' }
            }
          },
          physical_description: {
            type: 'text',
            fields: {
              keyword: { type: 'keyword' }
            }
          },
          primary_language: {
            type: 'keyword'
          },
          available_copies: { type: 'long' },
          bnumber: {
            type: 'text',
            fields: {
              keyword: { type: 'keyword' }
            }
          },
          set_type: {
            type: 'keyword'
          },
          area_of_study: {
            type: 'keyword'
          },
          created_at: {
            type: 'date',
            format: 'strict_date_optional_time||epoch_millis'
          },
          updated_at: {
            type: 'date',
            format: 'strict_date_optional_time||epoch_millis'
          },
          subjects: {
            type: 'nested',
            properties: {
              id: { type: 'long' },
              title: {
                type: 'text',
                fields: {
                  keyword: { type: 'keyword' }
                }
              },
              created_at: {
                type: 'date',
                format: 'strict_date_optional_time||epoch_millis'
              },
              updated_at: {
                type: 'date',
                format: 'strict_date_optional_time||epoch_millis'
              }
            }
          }
        }
      }
    }

    index_name = 'teacherset'
    ElasticSearch.new.create_or_update_index(index_name, body)
  end

  desc 'Create Elasticsearch mappings and index for teacherset subjects'
  task delete_teacherset_index: :environment do
    require 'elasticsearch'

    index_name = 'teacherset'
    ElasticSearch.new.delete_index(index_name)
  end
end

