# frozen_string_literal: true

class ElasticSearch

  def initialize(index=nil)
    arguments = {
      host: ENV['ELASTIC_SEARCH_HOST'],
      transport_options: {
        request: { open_timeout: 10 },
        headers: { content_type: 'application/json' }
      }
    }
    
    @client = Elasticsearch::Client.new(arguments)
    @current_file = File.basename(__FILE__)
    @index = index || 'techerset_index'
    @type = 'teacher_set'
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
    keyword = params["keyword"]
    g_begin = params["grade_begin"]
    g_end = params["grade_end"]
    language = params["language"]
    set_type = params['set type']
    availability = params['availability']
    area_of_study = params['area of study']

    query = {:query=> {:bool=> {:must=> []}}}

    if keyword.present? || (g_begin.present? && g_end.present?) || language.present? || set_type.present? || availability.present? || area_of_study.present?
      if keyword.present?
        query[:query][:bool][:must] << {:multi_match=>{:query=> keyword, :fields=>["title^8", "description", "contents"]}}
      end

      if g_begin.present? && g_end.present?
        query[:query][:bool][:must] << {:range=>{:grade_begin=>{:lte=> g_end.to_i}}}
        query[:query][:bool][:must] << {:range=>{:grade_end=>{:gte=> g_begin.to_i}}}
      end

      if language.present?
        query[:query][:bool][:must] << {:multi_match=>{:query=> language.join, :fields=>["language", "primary_language"]}}
      end

      if set_type.present?
        query[:query][:bool][:must] << {:match=>{:set_type=> set_type.join}}
      end

      if availability.present?
        query[:query][:bool][:must] << {:match=>{:availability=> availability.join}}
      end

      if area_of_study.present?
        query[:query][:bool][:must] << {:match=>{:area_of_study=> area_of_study.join}}
      end
    end

    query[:from] = from;
    query[:size] = size;
    query[:sort] = [{"_score": "desc", "availability.raw": "asc", "created_at": "desc", "_id": "asc"}]
    results = search_by_query(query)

    
    if !results[:hits].present? && keyword.present? && query[:query][:bool][:must].present?
      if query[:query][:bool][:must][0][:multi_match].present?
        query[:query][:bool][:must][0][:multi_match][:fuzziness] = 1
        results = search_by_query(query)
      end
    end
    results
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

  def get_document_by_id(index, type, id)
    start_time = Time.now
    response = @client.get index: index, type: type, id: id
    response
  end

  def update(id, query)
    start_time = Time.now
    @client.update(index: @index, type: @type, id: id, body: {doc: query}, refresh: true)
  end

  def bulk_update(updates)
    start_time = Time.now
    response = @client.bulk({body: updates})
    response
  end

  def delete_document_by_id(id)
    start_time = Time.now
    response = @client.delete index: @index, type: @type, id: id
    response
  end

  def delete_by_query(query)
    start_time = Time.now
    response = @client.delete_by_query(index: @index, body: query)
    response
  end
end

