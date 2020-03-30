class ElasticSearchController < ApplicationController

  SEARCH_TYPES = {PARTIAL: 'partial', FUZZY: 'fuzzy'}
  FROM = 0;
  SIZE = 50;

  def index
    @es_resp = nil;
    @suggested_result = nil;
    @fuzzy_count_arr = [1,2,3,4,5]
    begin
      if params.present? && params['search_keyword'].present? && params['search'].present?
        if params['search'] == SEARCH_TYPES[:PARTIAL]
          @es_resp = ElasticSearch.new.partial_search_by_query(params['search_keyword'], FROM, SIZE)
        elsif params['search'] == SEARCH_TYPES[:FUZZY]
          @es_resp = ElasticSearch.new.fuzzy_search_by_query(params['search_keyword'], FROM, SIZE, params['fuzzyness'])
        end
        @suggested_result = es_suggestions(params['search_keyword']) unless @es_resp[:hits].present?
      end
      respond_to do |format|
        format.js
        format.html
      end
    rescue => exception
      flash[:error] = "We've encountered Elastic Search error.#{exception.message}"
       respond_to do |format|
        format.html # new.html.erb
        format.json { render json: flash[:error] }
      end
    end
  end

  def es_suggestions(value)
    value = value
    result = "";
    if value.present?
      corrector = SpellingCorrectorController.new
      input_arr = value.split
      result_arr = input_arr.map{|i| corrector.correct("#{i}") }
      result = result_arr.uniq.join(" ")
    end
    result.titleize
  end
end
