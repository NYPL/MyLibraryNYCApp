module MlnHelper
	#Validating the empty values(string, nil, empty array)
  def validate_empty_values(input_params)
    input_params.each do |input|
      raise MlnException::InvalidInputException.new(MlnResponse::INVALID_INPUT[:code], 
            MlnResponse::INVALID_INPUT[:msg], input[:error_msg]) unless input[:value].present?
    end
  end


  def parse_request_body(request)
    request.body.rewind
    body = request.body.read
    raise InvalidInputException.new(EMPTY_REQUEST_BODY[:code],EMPTY_REQUEST_BODY[:msg]) unless body.present?

    raise InvalidInputException.new(MLN_INVALID_REQUEST_BODY[:code],
                                    MLN_INVALID_REQUEST_BODY[:msg]) unless json_valid?(body)
    JSON.parse body
  end


  def json_valid?(str)
    JSON.parse(str)
    true
  rescue JSON::ParserError
    false
  end
end