# frozen_string_literal: true

module BibServiceApi
  # Sends a request to the items microservice.
  # Calling items service api by pagination, fetching 25 items by each call pushing into array.
  # If its getting less than 25 items by items service call, we are not calling again.
  def send_request_to_items_microservice(bibid,offset = nil,response = nil,items_hash = {})
    limit = 25
    offset = offset.nil? ? 0 : offset += 1
    request_offset = limit.to_i * offset.to_i
    items_found = response && (response.code == 200 || items_hash['data'].present?)

    if response && (response.code != 200 || (items_hash['data'].present? && response['data'].size.to_i < limit))
      return items_hash, items_found
    else
      items_query_params = "?bibId=#{bibid}&limit=#{limit}&offset=#{request_offset}"
      response = HTTParty.get(ENV['ITEMS_MICROSERVICE_URL_V01'] + items_query_params, 
                              headers: { 'authorization' => "Bearer #{Oauth.get_oauth_token}", 
                                         'Content-Type' => 'application/json' }, timeout: 10)
      
      if response.code == 200 || items_hash['data'].present?
        resp = ENV['RAILS_ENV'] == 'test' ? JSON.parse(response) : response
        items_hash['data'] ||= []
        items_hash['data'] << resp['data'] if resp['data'].present?
        items_hash['data'].flatten!
        LogWrapper.log('DEBUG', {
          'message' => "Response from item services api",
          'method' => 'send_request_to_items_microservice',
          'status' => response.code,
          'responseData' => response.message
        })
      elsif response.code == 404
        items_hash = response
        LogWrapper.log('DEBUG', {
          'message' => "The items service could not find the Items with bibid=#{bibid}",
          'method' => 'send_request_to_items_microservice',
          'status' => response.code
        })
      else
        LogWrapper.log('ERROR', {
          'message' => "An error has occured when sending a request to the bibs service bibid=#{bibid}",
          'method' => 'send_request_to_items_microservice',
          'status' => response.code
        })
      end
    end

    # Recursive call
    send(__method__, bibid, offset, response, items_hash)
  end


  # Sends a request to the bibs microservice.(Get bib response by bibid)
  # Sierra-bib-response-by-bibid-url: "{BIBS_MICROSERVICE_URL_V01}/nyplSource=#{SIERRA_NYPL}&id=#{bibid}"
  def send_request_to_bibs_microservice(bibid)
    bib_query_params = "?nyplSource=#{SIERRA_NYPL}&id=#{bibid}"
    response = HTTParty.get(ENV['BIBS_MICROSERVICE_URL_V01'] + bib_query_params, headers: { 'Authorization' => "Bearer #{Oauth.get_oauth_token}", 
      'Content-Type' => 'application/json' }, timeout: 10)

    if response.code == 200
      LogWrapper.log('DEBUG', {
        'message' => "Response from bib services api",
        'method' => 'send_request_to_bibs_microservice',
        'status' => response.code,
        'responseData' => response.message
      })
    elsif response.code == 404
      LogWrapper.log('DEBUG', {
        'message' => "The bib service could not find with bibid=#{bibid}",
        'method' => 'send_request_to_bibs_microservice',
        'status' => response.code
      })
    else
      LogWrapper.log('ERROR', {
        'message' => "An error has occured when sending a request to the bibs service bibid=#{bibid}",
        'method' => 'send_request_to_bibs_microservice',
        'status' => response.code
      })
    end
    response
  end
end
