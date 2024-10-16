# frozen_string_literal: true

require "aws_decrypt"
# frozen_string_literal: true

class ElasticSearch

  include MlnException
  include MlnResponse

  AVAILABILITY_LABELS = {'available' => 'Available', 'unavailable' => 'Checked Out'}.freeze
  SET_TYPE_LABELS = {'single' => 'Book Club Set', 'multi' => 'Topic Sets'}.freeze

  def initialize(_index = nil)
    # Load elastic search configs from 'config/elastic_search.yml'.
    @es_config = MlnConfigurationController.new.elasticsearch_config('teachersets')
    arguments = {
      host: es_host(@es_config),
      transport_options: {
        request: { open_timeout: @es_config['connect_timeout'] },
        headers: { content_type: 'application/json' }
      }
    }
    @client = Elasticsearch::Client.new(arguments)
    @current_file = File.basename(__FILE__)
    @index = @es_config['index'] || 'teacherset'
    @type = @es_config['type'] || 'teacherset'
    @teachersets_per_page = @es_config['teachersets_per_page'] || 10
    @size = @es_config['size'] || 10000
  end
  
  # Decode aws elastic-search url
  def es_host(config)
    return if !config['host'].present? || ENV['RAILS_ENV'] == "test"

    return config['host'] if ENV['RAILS_ENV'] == "local"

    es_host = AwsDecrypt.decrypt_kms(config['host'])
    return unless es_host.present?
    
    "https://#{es_host}"
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
  
  # Teacher set filter params
  def teacher_sets_input_params(params)
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
    
    # Per page showing 10 teachersets.
    page = params["page"].present? ? params["page"].to_i - 1 : 0
    from = page.to_i * @teachersets_per_page.to_i
    query, agg_hash = teacher_sets_query_based_on_filters(params)
    
    query[:from] = from
    query[:size] = @teachersets_per_page
    # Sorting teachersets based on availability and created_at values. 
    # Showing latest created teachersets.
    query[:sort] = teacher_sets_sort_order(params["sort_order"].to_i)
    query[:aggs] = agg_hash
    teacherset_docs = search_by_query(query)
    facets = facets_for_teacher_sets(teacherset_docs, params)
    [teacherset_docs, facets, teacherset_docs[:totalMatches]]
  rescue StandardError => e
    raise ElasticsearchException.new(ELASTIC_SEARCH_STANDARD_EXCEPTION[:code], e.message)
    
  end

  # Get elastic serach queries based on input filter params.
  def teacher_sets_query_based_on_filters(params)
    keyword, grade_begin, grade_end, language, set_type, availability, area_of_study, subjects = teacher_sets_input_params(params)
    query = {:query => {:bool => {:must => []}}}
    aggregation_hash = {}
    # If search keyword is present in filters, finding the search keyword in these fields [title, description, contents, subjects]
    # Subjects is a nested object.
    # If any search keyword have wrong spelling, still getting the elasticsearch documents with fuzziness.
    # Fuzziness means find similar terms and search term within a specified edit distance.
    # Eg: wrong spelling: 'hiden figurs', Still fuzziness will give results like "Hidden Figures"

    if keyword.present?
      subjects_query = {:nested => {:path => "subjects", :query => 
      [
        {:multi_match => {:query => keyword, :type => "phrase_prefix", :boost => 3, :fields => ["subjects.title^3"]}},
        {:multi_match => {:query => keyword, :fuzziness => 1, :fields => ["subjects.title^3"]}}
      ]}}
      query[:query][:bool][:must] << {:bool => {:should => 
      [
        {:multi_match => {:query => keyword, :type => "phrase_prefix", :boost => 3, :fields => ["title^10", "description^2", "contents"]}},
        {:multi_match => {:query => keyword, :fuzziness => 1, :fields => ["title^10", "description^2", "contents"]}},
        subjects_query, {:term => {:'title.keyword' => {:value => keyword}}}
      ]}}
    end

    # If grade_begin, grade_end ranges present in filters get ES query based on ranges.
    # grade_begin value should be less than grade_end value
    # grade_end value should be greater than grade_begin value
    if grade_begin.present? && grade_end.present?
      query[:query][:bool][:must] << {:range => {:grade_begin => {:lte => grade_end.to_i}}}
      query[:query][:bool][:must] << {:range => {:grade_end => {:gte => grade_begin.to_i}}}
    end

    # If language present in filters finding the language in these fields [language, primary_language]
    if language.present?
      query[:query][:bool][:must] << {:multi_match => {:query => language.join, :fields => %w[primary_language]}}
    end
    

    # If set_type present in filters get ES query based on set_type.
    # Eg: set_type: single/multi
    if set_type.present?
      query[:query][:bool][:must] << {:match => {:set_type => set_type.join}}
    end

    # If availability present in filters get ES query based on availability.
    # Eg: availability: "available/unavailable"
    if availability.present?
      query[:query][:bool][:must] << {:match => {:availability => availability.join}}
    end

    # If area_of_study present in filters get ES query based on area_of_study.
    # Eg: area_of_study: "Social Studies"
    if area_of_study.present?
      query[:query][:bool][:must] << {:match => {:area_of_study => area_of_study.join}}
    end

    # If subjects present in filters get ES query based on subjects.
    # teacherset have has_many  relationship with subject.
    # subjects mapping are stored in nested format in elastic search. 
    if subjects.present?
      query[:query][:bool][:must] << {:nested => {:path => "subjects", 
                                      :query => {:bool => {:must => [{:terms => {"subjects.id" => params["subjects"]}}]}}}}
    end
    aggregation_hash = group_by_facets_query(aggregation_hash)
    [query, aggregation_hash]
  end

  # Groupby facets elastic search queries. (language, set_type, availability, area_of_study, subjects)
  def group_by_facets_query(aggregation_hash)
    aggregation_hash["language"] = { terms: { field: "primary_language", :size => 100, :order => {:_key => "asc"} } }
    aggregation_hash["set type"] = { terms: { field: "set_type", :size => 10, :order => {:_key => "asc"} } }
    # Remove Availability lable in facets.
    # aggregation_hash["availability"] = { "terms": { "field": "availability.raw", :size => 10, :order => {:_key => "asc"} } }
    aggregation_hash["area of study"] = { terms: { field: "area_of_study", :size => 100, :order => {:_key => "asc"} } }

    aggregation_hash["subjects"] = {:nested => {:path => "subjects"}, 
    :aggregations => {:subjects => {:composite => {:size => 3000, :sources => [{:id => {:terms => {:field => "subjects.id"}}}, 
                                                                               {:title => {:terms => {:field => "subjects.title.keyword"}}}]}}}}
    aggregation_hash
  end  
  
  # Get teacher set facets
  def facets_for_teacher_sets(teacher_sets_docs, params)
    facets = []
    # Get all facets from elastic search.
    facets = get_language_availability_set_type_area_of_study_facets(teacher_sets_docs, facets)

    subjects_facets = get_subject_facets(teacher_sets_docs, facets, params)
    facets << subjects_facets

    # Specify desired order of facets:
    facets.sort_by! do |f|
      ind = ['area of study', 'subjects', 'language','set type'].index f[:label]
      ind.nil? ? 1000 : ind
    end

    # Set order of facet vals:
    facets.each do |f|
      f[:items].sort_by! { |i| i[:label] }
    end
    facets
  end
 
  # Group by facets from elasticsearch (language, availability, set_type, area_of_study) 
  def get_language_availability_set_type_area_of_study_facets(teacherset_docs, facets)
    [
      { :label => 'language', :column => :primary_language },
      { :label => 'set type', :column => 'set_type' },
      { :label => 'area of study', :column => 'area_of_study' }
    ].each do |config|

      facets_group = {:label => config[:label], :items => []}
      # eg: aggregation_name = 'language' or 'availability' etc
      aggregation_name = config[:label]
      aggregations = teacherset_docs[:aggregations][aggregation_name.to_s]

      if aggregations.present? && aggregations["buckets"].present?
        teacherset_docs[:aggregations][aggregation_name.to_s]["buckets"].each do |agg_val|
          label = agg_val['key']
          unless config[:value_map].nil?
            label = config[:value_map][agg_val['key']]
            next if label.nil?
          end
          facets_group[:items] << {
            :value => agg_val['key'],
            :label => label,
            :count => agg_val['doc_count']
          }
        end
      end
      facets << facets_group
    end
    facets
  end

  # Get subject facets
  # facets eg: [ {:label=>"language", :items=> [{:value=>"Chinese", :label=>"Chinese", :count=>34}]},
  # {:label=>"availability", :items=>[{:value=>"available", :label=>"Available", :count=>1223}, {:value=>"unavailable", 
  # :label=>"Checked Out", :count=>32}]},
  # {:label=>"set type", :items=>[{:value=>"multi", :label=>"Topic Sets", :count=>910}, {:value=>"single", :label=>"Book Club Set", :count=>276}]},
  # {:label=>"area of study", :items=> [{:value=>"Arabic Language Arts.", :label=>"Arabic Language Arts.", :count=>1}]}]
  def get_subject_facets(teacherset_docs, facets, params)
    area_of_study_data = []
    # Collect area_of_study data for restricting subjects
    # area_of_study data eg:  ["Arabic Language Arts.", "Arts", "Arts." etc]
    unless (subjects_facet = facets.select { |f| f[:label] == 'area of study' }).nil?
      area_of_study_data = subjects_facet.first[:items].map { |s| s[:label] }
    end

    subjects_facets = {:label => 'subjects', :items => []}

    sub_aggs = teacherset_docs[:aggregations]["subjects"]

    if sub_aggs.present? || (sub_aggs["subjects"].present? && sub_aggs["subjects"]["buckets"].present?)
      sub_aggs["subjects"]["buckets"].each do |agg_val|
        # Restrict to min_count_for_facet (5).
        # but let's make it 5 consistently now.
        # and the next keyword is used to skip to the next iteration if conditions are not met.
        # if params['subjects'].blank? || (params['area of study'].blank? && params['set type'].blank? && params['language'].blank?)
        #   if agg_val['doc_count'] < Subject::MIN_COUNT_FOR_FACET
        #     next
        #   end
        # end
        if params['subjects'].blank? || params['subjects'].map(&:to_i).include?(agg_val["key"]["id"])
          subjects_facets[:items] << {
            :value => agg_val["key"]["id"],
            :label => agg_val["key"]["title"],
            :count => agg_val["doc_count"]
          }
        end
      end
    end
    # area_of_study data should not show in subjects.
    # area_of_study data eg:  ["Arabic Language Arts.", "Arts", "Arts." etc]
    subjects_facets[:items].delete_if do |subject|
      area_of_study_data.include?(subject[:label])
    end
    subjects_facets
  end

  def teacher_sets_sort_order(sort_order = 0)
    if [2, 3].include?(sort_order)
      sort_order = if sort_order == 2
                     "asc"
                   else
                     sort_order == 3 ? "desc" : "asc"
                   end
      query = [{:'title.keyword' => {:order => sort_order }}]
    elsif [0, 1].include?(sort_order)
      sort_order = if sort_order.zero?
                     "desc"
                   else
                     sort_order == 1 ? "asc" : "desc"
                   end
      query = [{_score: "desc", 'availability.raw': "asc", created_at: sort_order, _id: "asc"}]
    end
    query
  end
  
  # Search elastic documents based on the query.Eg: body: {id: "1234567", title: "test"}
  def search_by_query(body)
    LogWrapper.log('INFO', {'message' => "Elastic search query: #{body}", 
                            'method' => 'search_by_query'})
    results = {}
    resp = @client.search(index: @index, body: body)
    hits = resp['hits']
    num_of_matches = hits['total']
    results_hits = hits['hits']
    results_aggregations = resp['aggregations']
    results[:totalMatches] = num_of_matches
    results[:hits] = results_hits.uniq
    results[:aggregations] = {}
    if results_aggregations.present?
      results[:aggregations] = results_aggregations
    end
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
    @client.delete_by_query(index: @index, body: query)
    
  end
end
