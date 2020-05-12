# frozen_string_literal: true

class ElasticSearch
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


  # Elastic search documents based on the query.Eg: body: {id: "1234567", title: "test"}
  def search_by_query(body)
    results = {}
    resp = @client.search(index: @index, body: body)
    hits = resp['hits']
    num_of_matches = hits['total']
    results_hits = hits['hits']
    results[:totalMatches] = num_of_matches
    results[:hits] = results_hits.uniq
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
