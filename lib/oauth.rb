# frozen_string_literal: true

module Oauth
  def self.get_oauth_token
    response = HTTParty.post(ENV.fetch('ISSO_OAUTH_TOKEN_URL', nil), body: {
        grant_type: 'client_credentials',
        client_id: ENV.fetch('ISSO_CLIENT_ID', nil),
        client_secret: ENV.fetch('ISSO_CLIENT_SECRET', nil)
      })

    case response.code
    when 200
      LogWrapper.log('INFO', {
        'message' => 'Token successfully received',
        'status'=> response.code,
        })
      JSON.parse(response.body)['access_token']
    else
     LogWrapper.log('ERROR', {
       'message' => 'Error in receiving response from ISSO NYPL TOKEN SERVICE',
       'responseData' => "#{response.body}",
       'status' => response.code
       })
      raise InvalidResponse, "Invalid status code of: #{response.code}"
    end
  end
end
