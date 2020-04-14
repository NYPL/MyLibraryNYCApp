# frozen_string_literal: true

class ElasticSearch

	def initialize(index=nil)
    es_config = 'http://localhost:9200/'
    arguments = {
      host: es_config,
      transport_options: {
        request: { open_timeout: 10 },
        headers: { content_type: 'application/json' }
      }
    }
    
    @client = Elasticsearch::Client.new(arguments)
    @current_file = File.basename(__FILE__)
    @index = index || 'ts_index'
    @type = 'teacher_set'

    #ts_index211
  end

  def index_doc_count
    start_time = Time.now
    response = @client.perform_request 'GET', @index+'/_count'
    total_docs = response.body['count']
    total_docs
  end

  def create_document(id, body)
    @client.create index: @index, type: @type, id: id, body: body
  end

  def delete_document_by_id(id)
    start_time = Time.now
    response = @client.delete index: @index, type: @type, id: id
    response
  end

  def partial_search_by_query(keyword, from , size)
    query = {"from": from, "size": size, "query": {"multi_match": {"query": keyword, "fields": ["title", "description", "contents"]}}}
    search_by_query(query)
  end

  def fuzzy_search_by_query(keyword, from, size, fuzzy_val)
    query = {"query": {"multi_match": {"query": keyword, "fields": ["title", "description", "contents"], "fuzziness": fuzzy_val}}}
    search_by_query(query)
  end

  def get_teacher_sets_from_es(params)
    page = params["page"].present? ? params["page"].to_i - 1 : 0
    size = 20
    from = page.to_i * size.to_i
    keyword = params["keyword"] if params["keyword"].present?
    query = {}    
    if keyword.present? && params["grade_begin"].present? && params["grade_end"].present?
     query = {:query=>
          {:bool=>
            {:must=>
              [{:range=>{:grade_begin=>{:gte=> params["grade_begin"].to_i}}},
               {:range=>{:grade_end=>{:gte=> params["grade_begin"].to_i}}},
               {:range=>{:grade_begin=>{:lte=> params["grade_end"].to_i}}},
               {:range=>{:grade_end=>{:lte=> params["grade_end"].to_i}}},
               {:multi_match=>{:query=> keyword, :fields=>["title", "description", "contents"]}}]}}}
    elsif keyword.present?
      query = {:query=> {:bool=> {:must=> {:multi_match=>{:query=> keyword, :fields=>["title", "description"]}} }}}
    elsif params["grade_begin"].present? && params["grade_end"].present?
      query = {:query=> {:bool=> {:must=>
                [{:range=>{:grade_begin=>{:gte=> params["grade_begin"].to_i}}},
                 {:range=>{:grade_end=>{:gte=> params["grade_begin"].to_i}}},
                 {:range=>{:grade_begin=>{:lte=> params["grade_end"].to_i}}},
                 {:range=>{:grade_end=>{:lte=> params["grade_end"].to_i}}}]
               }}}
    end
    query[:from] = from;
    query[:size] = size;
    query[:sort] = [{ "availability.raw": {"order": "asc"}}, { "available_copies": "desc" }, { "id": "desc" }]
    results = search_by_query(query)
    #binding.pry
    unless results[:hits].present?
      query = {"query": {"multi_match": {"query": keyword, "fields": ["title", "description", "contents"], "fuzziness": 1}}}
      results = search_by_query(query)
    end
    results
  end

  def get_teacher_set_grades(grade_begin, grade_end)

    [{:range=>{:grade_begin=>{:gte=> params["grade_begin"].to_i}}},
    {:range=>{:grade_end=>{:gte=> params["grade_begin"].to_i}}},
    {:range=>{:grade_begin=>{:lte=> params["grade_end"].to_i}}},
    {:range=>{:grade_end=>{:lte=> params["grade_end"].to_i}}}]
          
  end

  def search_by_query(body)
    results = {}
    start_time = Time.now
    resp = @client.search(index: @index, body: body)
    hits = resp['hits']
    num_of_matches = hits['total']
    results_hits = hits['hits']
    results[:totalMatches] = num_of_matches
    results[:hits] = results_hits.uniq
    results
  end

  def bulk_update(updates)
    start_time = Time.now
    response = @client.bulk({body: updates})
    response
  end

  def delete_by_query(query)
    start_time = Time.now
    response = @client.delete_by_query(index: @index, body: query)
    response
  end

  def get_document_by_id(index, type, id)
    start_time = Time.now
    response = @client.get index: index, type: type, id: id
    response
  end

  def update(id, query, type='user')
    start_time = Time.now
    response = @client.update(index: @index, type: type, id: id, body: query)
    response
  end

  def es_suggestions(query, fields)
    suggestions_arr = []
    begin
      result = search_by_query(query)
      fields.each do |field|
        suggestions_arr << result[:suggestions]["#{field}"][0]["options"].collect{|data| data['text']}
      end
      suggestions_arr.flatten.uniq if suggestions_arr.present?
    rescue Exception => e
      raise e.message
    end
  end

  def get_search_results(_type, params)
    start_time = Time.now
    request_payload = {
      id:' @es_template_id',
      params: params
    }
    results = {}
    resp = nil
    error_es = "error"
    begin
      resp = @client.search_template index: @index, type: _type, body: request_payload
    rescue Elasticsearch::Transport::Transport::Errors::BadRequest => e
      raise 'error'
    end
    raise error_es if resp.nil? || resp['hits'].nil? || resp['hits']['total'].nil?\
                        || resp['hits']['hits'].nil? || resp['hits']['hits'].length.nil?

    hits = resp['hits']
    num_of_matches = hits['total']
    results_hits = hits['hits']

    results[:totalMatches] = num_of_matches
    results[:hits] = results_hits
    results
  end
end
