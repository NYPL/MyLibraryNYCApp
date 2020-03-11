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
end