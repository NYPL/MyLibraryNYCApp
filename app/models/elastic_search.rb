# frozen_string_literal: true

class ElasticSearch

  AVAILABILITY_LABELS = {'available' => 'Available', 'unavailable' => 'Checked Out'}
  SET_TYPE_LABELS = {'single' => 'Book Club Set', 'multi' => 'Topic Sets'}

  def initialize(_index = nil)
    # Load elastic search configs from 'config/elasticsearch_config.yml'.
    @es_config = MlnConfigurationController.new.elasticsearch_config('teachersets')
    arguments = {
      host: @es_config['host'],
      transport_options: {
        request: { open_timeout: @es_config['connect_timeout'] },
        headers: { content_type: 'application/json' }
      }
    }
    @client = Elasticsearch::Client.new(arguments)
    @current_file = File.basename(__FILE__)
    @index = @es_config['index'] || 'teacherset'
    @type = @es_config['type'] || 'teacherset'
    @size = @es_config['size'] || 20
  end


  # Create elastic search document by id and body. Eg: id: "1234567", body: {id: "1234567", title: "test"}
  def create_document(id, body)
    response = @client.create index: @index, type: @type, id: id, body: body
    LogWrapper.log('DEBUG', {'message' => "ES document successfully created. Id: #{id}", 
                             'method' => 'create_document'})
    response
  end


  # Delete elastic search document by id. Eg: id: "1234567"
  def delete_document_by_id(id)
    response = @client.delete index: @index, type: @type, id: id
    LogWrapper.log('DEBUG', {'message' => "ES document successfully deleted. Id: #{id}", 
                             'method' => 'delete_document_by_id'})

    response
  end


  def teacher_sets_params(params)
    keyword = params["keyword"]
    grade_begin = params["grade_begin"]
    grade_end = params["grade_end"]
    language = params["language"]
    set_type = params['set type']
    availability = params['availability']
    area_of_study = params['area of study']
    subjects = params['subjects']
    [keyword, grade_begin, grade_end, language, set_type, availability, area_of_study, subjects]
  end


  # Get teacher sets documents from elastic search.
  def get_teacher_sets_from_es(params)
    # Per page showing 20 teachersets.
    page = params["page"].present? ? params["page"].to_i - 1 : 0
    from = page.to_i * @size.to_i
    query = teacher_sets_query_based_on_filters(params)
    query[:from] = from
    query[:size] = @size

    # Sorting  the teachersets based on availability and created_at values. 
    # Showing latest created teachersets.
    query[:sort] = [{"_score": "desc", "availability.raw": "asc", "created_at": "desc", "_id": "asc"}]
    results = search_by_query(query)

    # Eg: If any search keyword have wrong spelling, querying the elasticsearch query with fuzziness.
    # Fuzziness means find similar terms and search term within a specified edit distance.
    if !results[:hits].present? && params["keyword"].present? && query[:query][:bool][:must].present?
      if query[:query][:bool][:must][0][:multi_match].present?
        query[:query][:bool][:must][0][:multi_match][:fuzziness] = 1
        results = search_by_query(query)
      end
    end
    results
  end


  # Get elastic serach queries based on input filter params.
  def teacher_sets_query_based_on_filters(params)
    keyword, grade_begin, grade_end, language, set_type, availability, area_of_study, subjects = teacher_sets_params(params)
    query = {:query => {:bool => {:must => []}}}

    # If search keyword is present in filters, finding the search keyword in these fields [title, description, contents]
    if keyword.present?
      query[:query][:bool][:must] << {:multi_match => {:query => keyword, :fields => %w[title^8 description contents]}}
    end

    # If grade_begin, grade_end is present in filters get ES query based on ranges.
    # grade_begin value should be less than grade_end value
    # grade_end value should be greater than grade_begin value
    if grade_begin.present? && grade_end.present?
      query[:query][:bool][:must] << {:range => {:grade_begin => {:lte => grade_end.to_i}}}
      query[:query][:bool][:must] << {:range => {:grade_end => {:gte => grade_begin.to_i}}}
    end

    # If language is present in filters finding the language in these fields [language, primary_language]
    if language.present?
      query[:query][:bool][:must] << {:multi_match => {:query => language.join, :fields => %w[language primary_language]}}
    end

    # If set_type is present in filters get ES query based on set_type.
    # Eg: set_type: single/multi

    if set_type.present?
      query[:query][:bool][:must] << {:match => {:set_type => set_type.join}}
    end

    # If availability is present in filters get ES query based on availability.
    # Eg: availability: "available/unavailable"
    if availability.present?
      query[:query][:bool][:must] << {:match => {:availability => availability.join}}
    end

    # If area_of_study is present in filters get ES query based on area_of_study.
    # Eg: area_of_study: "Social Studies"
    if area_of_study.present?
      query[:query][:bool][:must] << {:match => {:area_of_study => area_of_study.join}}
    end

    # If subjects is present in filters get ES query based on subjects.
    # teacherset have has_many  relationship with subject.
    # subjects mapping are stored in nested format in elastic search. 
    if subjects.present?
      query[:query][:bool][:must] << {:nested => {:path => "subjects", :query => {:bool => {:must => {:terms => {"subjects.id" => subjects}}}}}}
    end
    query
  end

  def facets_for_query(teacher_sets)
    facets = []
    [
        { :label => 'language',
          :column => :primary_language
        },
        { :label => 'availability',
          :column => 'availability',
          :value_map => AVAILABILITY_LABELS
        },
        { :label => 'set type',
          :column => 'set_type',
          :value_map => SET_TYPE_LABELS
        },
        { :label => 'area of study',
          :column => 'area_of_study'
        }
      ].each do |config|
          facets_group = {:label => config[:label], :items => []}
          agg_name = "#{config[:column]}_aggs"
          config_column = config[:column] == "availability" ? 'availability.raw' : config[:column]
          query = {
                "aggs": {
                  "#{agg_name}": {
                    "terms": {
                      "field": config_column,
                      "size": 100,
                      "order": {"_key": "asc"}
                    }
                  }
                }
              }
        resp = search_by_query(query)
        resp[:aggregations][agg_name]["buckets"].each do |agg_val|

          label = config[:label]
          unless config[:value_map].nil?
            label = config[:value_map][agg_val['key']]
            next if label.nil?
          end

          facets_group[:items] << {
            :value => agg_val['key'],
            :label => agg_val['key'],
            :count => agg_val['doc_count']
          }
        end
        facets << facets_group
      end

      # Collect primary subjects for restricting subjects
      primary_subjects = []

      unless (subjects_facet = facets.select { |f| f[:label] == 'area of study' }).nil?
        primary_subjects = subjects_facet.first[:items].map { |s| s[:label] }
      end

      subjects_facets = {:label =>  'subjects', :items => []}

      primary_subjects_arr = []
      primary_subjects.each do |subject|
        primary_subjects_arr << { "match": { "subjects.title": subject }}
      end

      subjects_query = { 
        "size": 10000,
        "sort": {"_score": "desc", "availability.raw": "asc", "created_at": "desc", "_id": "asc"},
        "query": { "nested": { "path": "subjects", "query": { "bool": { "must_not": primary_subjects_arr } } } },
        "aggs": {
          "subjects": {
            "nested": {
            "path": "subjects"
          },
          "aggregations": {
            "subject_ids": { "terms": { "field": "subjects.id", "size": 100000 },
              "aggregations": { "subject_titles": { "terms": { "field": "subjects.title.keyword", "size": 10000000 }}}}
            } 
          }
        }
      }

      resp = search_by_query(subjects_query)

      resp[:aggregations]["subjects"]["subject_ids"]["buckets"].each do |agg_val|

        next if agg_val['doc_count'] < Subject::MIN_COUNT_FOR_FACET

        subjects_facets[:items] << {
          :value => agg_val["key"],
          :label => agg_val["subject_titles"]["buckets"].first["key"],
          :count => agg_val['doc_count']
        }
      end
      facets << subjects_facets


      # Specify desired order of facets:
      facets.sort_by! do |f|
        ind = ['area of study', 'subjects', 'language','set type','availability'].index f[:label]
        ind.nil? ? 1000 : ind
      end

      # Set order of facet vals:
      facets.each do |f|
        f[:items].sort_by! { |i| i[:label] }
      end
      facets
 end

  # Elastic search documents based on the query.Eg: body: {id: "1234567", title: "test"}
  def search_by_query(body)
    results = {}
    resp = @client.search(index: @index, body: body)
    hits = resp['hits']
    num_of_matches = hits['total']
    results_hits = hits['hits']
    results_aggregations = resp['aggregations']
    results[:totalMatches] = num_of_matches
    results[:hits] = results_hits.uniq
    results[:aggregations] = if results_aggregations.nil? then {} else results_aggregations end
    results
  end


  # Get elastic search document by id. Eg: id: "1234567"
  def get_document_by_id(id)
    response = @client.get index: @index, type: @type, id: id
    LogWrapper.log('DEBUG', {'message' => "Got ES document successfully. Id: #{id}", 
                             'method' => 'get_document_by_id'})
    response
  end


  # Update elastic search document by id and body. Eg: id: "1234567", body: {id: "1234567", title: "test"}
  def update_document_by_id(id, query)
    response = @client.update(index: @index, type: @type, id: id, body: {doc: query}, refresh: true)
    LogWrapper.log('DEBUG', {'message' => "ES document successfully updated. Id: #{id}", 
                             'method' => 'update_document_by_id'})
    response
  end


  # Delete elastic search document by body.Eg: body: {id: "1234567", title: "test"}
  def delete_by_query(query)
    response = @client.delete_by_query(index: @index, body: query)
    response
  end
end
