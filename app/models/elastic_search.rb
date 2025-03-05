# frozen_string_literal: true

require "aws_decrypt"
# frozen_string_literal: true

class ElasticSearch
  include MlnException
  include MlnResponse

  AVAILABILITY_LABELS = { "available" => "Available", "unavailable" => "Checked Out" }.freeze
  SET_TYPE_LABELS = { "single" => "Book Club Set", "multi" => "Topic Sets" }.freeze

  def initialize(_index = nil)
    # Load elastic search configs from 'config/elastic_search.yml'.
    @es_config = MlnConfigurationController.new.elasticsearch_config("teachersets")

    arguments = {
      host: es_host(@es_config),
      port: @es_config["port"],
      transport_options: {
        request: { open_timeout: @es_config["connect_timeout"] },
        headers: { content_type: "application/json" },
      },
    }
    @client = Elasticsearch::Client.new(arguments)
    @current_file = File.basename(__FILE__)
    @index = @es_config["index"] || "teacherset"
    @type = @es_config["type"] || "_doc"
    @teachersets_per_page = @es_config["teachersets_per_page"] || 10
    @size = @es_config["size"] || 10000
  end

  # Decode aws elastic-search url
  def es_host(config)
    return if !config["host"].present? || ENV["RAILS_ENV"] == "test"

    return config["host"] if ENV["RAILS_ENV"] == "development"

    es_host = AwsDecrypt.decrypt_kms(config["host"])
    return unless es_host.present?

    "https://#{es_host}"
  end

  # Create elastic search document by id and body. Eg: id: "1234567", body: {id: "1234567", title: "test"}
  def create_document(id, body)
    response = @client.create index: @index, type: @type, id: id, body: body
    LogWrapper.log("DEBUG", { "message" => "ES document successfully created. Id: #{id}",
                              "method" => "create_document" })
    response
  end

  # Delete elastic search document by id. Eg: id: "1234567"
  def delete_document_by_id(id)
    response = @client.delete index: @index, type: @type, id: id
    LogWrapper.log("DEBUG", { "message" => "ES document successfully deleted. Id: #{id}",
                              "method" => "delete_document_by_id" })

    response
  end

  # Teacher set filter params
  def teacher_sets_input_params(params)
    keyword = params["keyword"]
    grade_begin = params["grade_begin"]
    grade_end = params["grade_end"]
    language = params["language"]
    set_type = params["set type"]
    availability = params["availability"]
    area_of_study = params["area of study"]
    subjects = params["subjects"]
    [keyword, grade_begin, grade_end, language, set_type, availability, area_of_study, subjects]
  end

  # Get teacher sets documents from elastic search.
  def get_teacher_sets_from_es(params)
    # Per page showing 10 teachersets.
    page = params["page"].present? ? params["page"].to_i - 1 : 0
    from = page.to_i * @teachersets_per_page.to_i
    query, agg_hash, subjects_hash = teacher_sets_query_based_on_filters(params)
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
    query = { :query => { :bool => { :must => [] } } }
    # If search keyword is present in filters, finding the search keyword in these fields [title, description, contents, subjects]
    # Subjects is a nested object.
    # If any search keyword have wrong spelling, still getting the elasticsearch documents with fuzziness.
    # Fuzziness means find similar terms and search term within a specified edit distance.
    # Eg: wrong spelling: 'hiden figurs', Still fuzziness will give results like "Hidden Figures"

    if keyword.present?
      subjects_query = { :nested => { :path => "subjects", :query => [
        { :multi_match => { :query => keyword, :type => "phrase_prefix", :boost => 3, :fields => ["subjects.title^3"] } },
        { :multi_match => { :query => keyword, :fuzziness => 1, :fields => ["subjects.title^3"] } },
      ] } }
      query[:query][:bool][:must] << { :bool => { :should => [
        { :multi_match => { :query => keyword, :type => "phrase_prefix", :boost => 3, :fields => ["title^10", "description^2", "contents"] } },
        { :multi_match => { :query => keyword, :fuzziness => 1, :fields => ["title^10", "description^2", "contents"] } },
        subjects_query, { :term => { :'title.keyword' => { :value => keyword } } },
      ] } }
    end

    # If grade_begin, grade_end ranges present in filters get ES query based on ranges.
    # grade_begin value should be less than grade_end value
    # grade_end value should be greater than grade_begin value
    if grade_begin.present? && grade_end.present?
      query[:query][:bool][:must] << { :range => { :grade_begin => { :lte => grade_end.to_i } } }
      query[:query][:bool][:must] << { :range => { :grade_end => { :gte => grade_begin.to_i } } }
    end

    # If language present in filters finding the language in these fields [language, primary_language]
    if language.present?
      query[:query][:bool][:must] << { :terms => { :primary_language => language } }
    end

    # If set_type present in filters get ES query based on set_type.
    # Eg: set_type: single/multi
    if set_type.present?
      query[:query][:bool][:must] << { :terms => { :set_type => set_type } }
    end

    # If availability present in filters get ES query based on availability.
    # Eg: availability: "available/unavailable"
    if availability.present?
      query[:query][:bool][:must] << { :terms => { :availability => availability } }
    end

    # If area_of_study present in filters get ES query based on area_of_study.
    # Eg: area_of_study: "Social Studies"
    if area_of_study.present?
      query[:query][:bool][:must] << { :terms => { :area_of_study => area_of_study } }
    end

    # If subjects present in filters get ES query based on subjects.
    # teacherset have has_many  relationship with subject.
    # subjects mapping are stored in nested format in elastic search.
    if subjects.present?
      query[:query][:bool][:must] << { :nested => { :path => "subjects",
                                                   :query => { :bool => { :must => [{ :terms => { "subjects.id" => params["subjects"] } }] } } } }
    end
    aggregation_hash = group_by_facets_query(area_of_study, language, subjects, set_type, params)
    [query, aggregation_hash]
  end

  # Groupby facets elastic search queries. (language, set_type, availability, area_of_study, subjects)
  def group_by_facets_query(area_of_study, primary_language, subjects, set_type, params)
    aggregation_hash = {}
    must_conditions = [
      { range: { grade_begin: { lte: 12 } } },
      { range: { grade_end: { gte: -1 } } },
    ]

    must_conditions << { terms: { set_type: set_type } } if set_type.present?
    must_conditions << { terms: { primary_language: primary_language } } if primary_language.present?
    must_conditions << { terms: { area_of_study: area_of_study } } if area_of_study.present?
    must_conditions << { terms: { subjects: subjects } } if subjects.present?

    firstFacetSelectedItem = params["firstFacetSelectedItem"]
    selectedItemCount = params["selectedItemCount"]

    first_conditions = [
      { range: { grade_begin: { lte: 12 } } },
      { range: { grade_end: { gte: -1 } } },
    ]

    aggregation_hash[:aggs] = {
      total_aggregations: {
        global: {},
        aggs: {
          filtered_data: {
            filter: {
              bool: {
                must: must_conditions,
              },
            },
            aggs: {
              language: {
                terms: {
                  field: "primary_language",
                  size: 200,
                  order: { _key: "asc" },
                  min_doc_count: 0,  # Include even empty buckets
                },
              },
              'set type': {
                terms: {
                  field: "set_type",
                  size: 200,
                  order: { _key: "asc" },
                  min_doc_count: 0,  # Include even empty buckets
                },
              },
              'area of study': {
                terms: {
                  field: "area_of_study",
                  size: 200,
                  order: { _key: "asc" },
                  min_doc_count: 0,  # Include even empty buckets
                },
              },
              "subjects": {
                "nested": {
                  "path": "subjects",
                },
                "aggs": {
                  "id": {
                    "terms": {
                      "field": "subjects.id",
                      "size": 3000,
                    },
                  },
                  "title": {
                    "terms": {
                      "field": "subjects.title.keyword",
                      "size": 3000,
                    },
                  },
                },
              },
            },
          },
          "all_area_of_study": {
            "filter": {
              "bool": {
                "must": first_conditions,
              },
            },
            "aggs": {
              "area_of_study": {
                "terms": {
                  "field": "area_of_study",
                  "size": 200,
                  "order": {
                    "_key": "asc",
                  },
                  "min_doc_count": 0,
                },
              },
            },
          },
          "selected_area_override": {
            "filter": {
              "bool": {
                "must": must_conditions,
              },
            },
            "aggs": {
              "area_of_study": {
                "terms": {
                  "field": "area_of_study",
                  "size": 200,
                  "order": { "_key": "asc" },
                  "min_doc_count": 0,
                },
              },
              "language": {
                "terms": {
                  "field": "primary_language",
                  "size": 200,
                  "order": {
                    "_key": "asc",
                  },
                  "min_doc_count": 0,
                },
              },
              "set_type": {
                "terms": {
                  "field": "set_type",
                  "size": 200,
                  "order": {
                    "_key": "asc",
                  },
                  "min_doc_count": 0,
                },
              },
            },
          },
          "all_language": {
            "filter": {
              "bool": {
                "must": first_conditions,
              },
            },
            "aggs": {
              "language": {
                "terms": {
                  "field": "primary_language",
                  "size": 200,
                  "order": {
                    "_key": "asc",
                  },
                  "min_doc_count": 0,
                },
              },
            },
          },
          "all_set_type": {
            "filter": {
              "bool": {
                "must": first_conditions,
              },
            },
            "aggs": {
              "set_type": {
                "terms": {
                  "field": "set_type",
                  "size": 200,
                  "order": {
                    "_key": "asc",
                  },
                  "min_doc_count": 0,
                },
              },
            },
          },
        },
      },
    }
  end

  # Get teacher set facets
  def facets_for_teacher_sets(teacher_sets_docs, params)
    facets = []
    # Get all facets from elastic search.
    facets = get_language_availability_set_type_area_of_study_facets(teacher_sets_docs, facets, params)
    # Specify desired order of facets:
    facets.sort_by! do |f|
      ind = ["area of study", "subjects", "language", "set type"].index f[:label]
      ind.nil? ? 1000 : ind
    end

    # Set order of facet vals:
    facets.each do |f|
      f[:items].sort_by! { |i| i[:label] }
    end
    facets
  end

  def get_language_availability_set_type_area_of_study_facets(teacherset_docs, facets, params)
    firstFacetSelectedItem = params["firstFacetSelectedItem"]
    filters_applied = params["area of study"].present? || params["set type"].present? || params["language"].present? || params["subjects"].present?

    area_of_study = "area of study"
    set_type = "set type"
    language = "language"
    subjects = "subjects"

    if firstFacetSelectedItem.present?
      case firstFacetSelectedItem
      when "area of study"
        area_of_study = "all_area_of_study"
        another_value = "area_of_study"
        firstFacetSelectedItem = "all_area_of_study"
      when "set type"
        set_type = "all_set_type"
        another_value = "set_type"
        firstFacetSelectedItem = "all_set_type"
      when "language"
        language = "all_language"
        another_value = "language"
        firstFacetSelectedItem = "all_language"
      when "subjects"
        subjects = "subjects"
        another_value = "subjects"
        firstFacetSelectedItem = "subjects"
      end
    end

    [
      { label: "language", column: :primary_language, aggregation_name: language },
      { label: "set type", column: "set_type", aggregation_name: set_type },
      { label: "area of study", column: "area_of_study", aggregation_name: area_of_study },
      { label: "subjects", column: "subjects", aggregation_name: subjects },
    ].each do |config|
      facets_group = { label: config[:label], items: [] }
      aggregation_name = config[:aggregation_name]

      if firstFacetSelectedItem == aggregation_name.to_s
        aggregations = teacherset_docs.dig(:aggregations, "total_aggregations", aggregation_name.to_s, another_value.to_s)
      else
        aggregations = teacherset_docs.dig(:aggregations, "total_aggregations", "filtered_data", aggregation_name.to_s)
      end

      case aggregation_name
      when "subjects"
        if aggregations&.dig("id", "buckets") && aggregations&.dig("title", "buckets")
          id_buckets = aggregations["id"]["buckets"]
          title_buckets = aggregations["title"]["buckets"]

          if id_buckets.length == title_buckets.length
            id_buckets.each_with_index do |id_bucket, index|
              title_bucket = title_buckets[index]
              next if id_bucket["doc_count"] < Subject::MIN_COUNT_FOR_FACET

              facets_group[:items] << {
                value: id_bucket["key"],
                label: title_bucket["key"],
                count: id_bucket["doc_count"],
              }
            end
          end
        else
          facets_group[:items] << { value: "No data available", label: "No data available", count: 0 }
        end
      else
        if aggregations&.dig("buckets")
          buckets = aggregations["buckets"]

          if params["selectedItemCount"].to_i > 1
            # Extract override counts (generic for all values)
            override_counts = teacherset_docs.dig(:aggregations, "total_aggregations", "selected_area_override", "area_of_study", "buckets")

            # Create a hash of the override counts for fast lookups, but only for counts > 0
            override_count_hash = override_counts.each_with_object({}) do |bucket, hash|
              hash[bucket["key"]] = bucket["doc_count"] #if bucket["doc_count"] > 0
            end
          end

          buckets.each do |agg_val|
            # Override count if the area_of_study exists in the `selected_area_override` and doc_count > 0
            if params["selectedItemCount"].to_i > 1
              if override_count_hash.key?(agg_val["key"])
                agg_val["doc_count"] = override_count_hash[agg_val["key"]]
              end
            end

            facets_group[:items] << {
              value: agg_val["key"],
              label: agg_val["key"],
              count: agg_val["doc_count"],
            }
          end
        else
          facets_group[:items] << { value: "No data available", label: "No data available", count: 0 }
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
    # area_of_study data eg: ["Arabic Language Arts.", "Arts", "Arts." etc]
    unless (subjects_facet = facets.select { |f| f[:label] == "area of study" }).nil?
      area_of_study_data = subjects_facet.first[:items].map { |s| s[:label] }
    end
    subjects_facets = { label: "subjects", items: [] }

    sub_aggs = teacherset_docs[:aggregations]["total_aggregations"]["subjects"]

    if sub_aggs.present? || (sub_aggs["subjects"].present? && sub_aggs["subjects"]["buckets"].present?)

      # Initialize an array to hold id-title pairs
      id_buckets = sub_aggs["id"]["buckets"]
      title_buckets = sub_aggs["title"]["buckets"]

      # Ensure that id_buckets and title_buckets are equal in length before processing
      if id_buckets.length == title_buckets.length
        id_buckets.each_with_index do |id_bucket, index|
          title_bucket = title_buckets[index]

          # Ensure that doc_count is above the minimum threshold if necessary
          if id_bucket["doc_count"] < Subject::MIN_COUNT_FOR_FACET
            next
          end

          # Check if the current subject ID matches the parameters (if any)
          # Add the facet to the items list
          subjects_facets[:items] << {
            value: id_bucket["key"],   # ID as value
            label: title_bucket["key"], # Title as label
            count: id_bucket["doc_count"],
          }
        end
      end
    end
    # Remove area_of_study data from the subjects_facets items list
    # area_of_study data should not show in subjects
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
      query = [{ :'title.keyword' => { :order => sort_order } }]
    elsif [0, 1].include?(sort_order)
      sort_order = if sort_order.zero?
          "desc"
        else
          sort_order == 1 ? "asc" : "desc"
        end
      query = [{ _score: "desc", 'availability.raw': "asc", created_at: sort_order, _id: "asc" }]
    end
    query
  end

  # Search elastic documents based on the query.Eg: body: {id: "1234567", title: "test"}
  def search_by_query(body)
    LogWrapper.log("INFO", { "message" => "Elastic search query: #{body}",
                             "method" => "search_by_query" })
    results = {}
    resp = @client.search(index: @index, body: body)
    hits = resp["hits"]
    num_of_matches = hits["total"]
    results_hits = hits["hits"]
    results_aggregations = resp["aggregations"]
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
    LogWrapper.log("DEBUG", { "message" => "Got ES document successfully. Id: #{id}",
                              "method" => "get_document_by_id" })
    response
  end

  # Update elastic search document by id and body. Eg: id: "1234567", body: {id: "1234567", title: "test"}
  def update_document_by_id(id, query)
    response = @client.update(index: @index, type: @type, id: id, body: { doc: query }, refresh: true)
    LogWrapper.log("DEBUG", { "message" => "ES document successfully updated. Id: #{id}",
                              "method" => "update_document_by_id" })
    response
  end

  # Delete elastic search document by body.Eg: body: {id: "1234567", title: "test"}
  def delete_by_query(query)
    @client.delete_by_query(index: @index, body: query)
  end

  def create_or_update_index(index_name, body)
    begin
      if @client.indices.exists?(index: index_name)
        puts "Index #{index_name} already exists. Updating..."
        @client.indices.put_mapping(index: index_name, body: body[:mappings])
      else
        puts "Creating index #{index_name}..."
        @client.indices.create(index: index_name, body: body)
      end
      puts "Index #{index_name} created/updated successfully."
    rescue StandardError => e
      puts "Error: #{e.message}"
    end
  end

  def delete_index(index_name)
    begin
      if @client.indices.exists?(index: index_name)
        puts "Deleting index #{index_name}..."
        @client.indices.delete(index: index_name)
        puts "Index #{index_name} deleted successfully."
      else
        puts "Index #{index_name} does not exist."
      end
    rescue StandardError => e
      puts "Error: #{e.message}"
    end
  end
end
