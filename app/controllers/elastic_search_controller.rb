class ElasticSearchController < ActionController::Base
  layout 'application'

  SEARCH_TYPES = {PARTIAL: 'partial', FUZZY: 'fuzzy'}
  FROM = 0;
  SIZE = 50;

  def index
    @es_resp = nil
    @fuzzy_count_arr = [1,2,3,4,5]
    begin
      if params.present? && params['search_keyword'].present? && params['search'].present?
        if params['search'] == SEARCH_TYPES[:PARTIAL]
          @es_resp = ElasticSearch.new.partial_search_by_query(params['search_keyword'], FROM, SIZE)
        elsif params['search'] == SEARCH_TYPES[:FUZZY]
          @es_resp = ElasticSearch.new.fuzzy_search_by_query(params['search_keyword'], FROM, SIZE, params['fuzzyness'])
        end        
      end
      respond_to do |format|
        format.js
        format.html
      end
    rescue => exception
      flash[:error] = "We've encountered Elastic Search error.#{exception.message}"
    end     
  end

  def es_suggestions
    search_fields = ['title', 'description', 'contents']
    query = es_search_suggestions_query(params[:value])
    es_data =  ElasticSearch.new.es_suggestions(query, search_fields)
    es_arr = []
    es_data.each_with_index{|data, index|
      hash = {}
      hash[:id] = index
      hash[:value] = data
      es_arr << hash
    }
    respond_to do |format|
      format.html
      format.json {render json: es_arr}
    end
  end


  def es_search_suggestions_query(keyword)
    query = {
      "suggest": {
        "text": keyword,
        "title": {
          "phrase": {
            "field": "title",
            "confidence": 0.0,
            "direct_generator": [
              {
                "field": "title"
              }
            ]
          }
        },
        "description": {
          "phrase": {
            "field": "description",
            "confidence": 0.0,
            "direct_generator": [
              {
                "field": "description"
              }
            ]
          }
        },
        "contents": {
          "phrase": {
            "field": "contents",
            "confidence": 0.0,
            "direct_generator": [
              {
                "field": "contents"
              }
            ]
          }
        }
      }
    }
  end
end


