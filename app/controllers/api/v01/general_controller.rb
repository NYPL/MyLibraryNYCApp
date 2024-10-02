# frozen_string_literal: true

class Api::V01::GeneralController < ApplicationController
  include LogWrapper

  def unauthorized
    render json: { message: 'Unauthorized message from MLN Api::V01::GeneralController' }, status: 401
  end

  private

  # set the @request_body instance variable so it can be used in other methods;
  # check for parsing errors.
  def set_request_body
    begin
      @request_body = params[:_json] || JSON.parse(request.body.read)
    rescue => e
      @parsing_error = e
    end
  end
  
  # this validates that the request is in the correct format
  def validate_request
    if @parsing_error
      return [400, "Parsing error: #{@parsing_error}"]
    elsif !@request_body || @request_body.empty?
      return [400, 'Request body is empty.']
    end

    return []
  end
  
  # Requests to the MLN teacher set-updating api must come from our verified lambdas,
  # unless are being tested or developed.
  def validate_source_of_request
    LogWrapper.log('DEBUG', {
        'message' => "Request sent to #{params['controller']}Controller#validate_source_of_request",
        'method' => 'validate_source_of_request',
        'status' => "start, Rails.env=#{Rails.env}, (Rails.env.test? || Rails.env.development?)=#{Rails.env.test? || Rails.env.development?}",
        'dataSent' => "request.headers['X-API-Key']:#{request.headers['X-API-Key']}"
      })

    redirect_to '/api/unauthorized' unless Rails.env.test? || Rails.env.development? || request.headers['X-API-Key'] == ENV['API_GATEWAY_HEADER_KEY']
  end
  
  # log the error and render it back to the lambda
  def render_error(error_code_and_message)
    LogWrapper.log('ERROR', {
      'message' => error_code_and_message[1],
      'method' => "#{controller_name}##{action_name}",
      'status' => error_code_and_message[0]
    })
    return api_response_builder(error_code_and_message[0], {message: error_code_and_message[1]}.to_json)
  end
  
  # Prepare and write an error message to the application log.
  def log_error(method, exception)
    if method.blank?
      method = "#{controller_name or 'unknown_controller'}##{action_name or 'unknown_action'}"
    end

    message = (exception&.message ? exception.message[0..200] : 'exception or exception message missing')
    backtrace = (exception ? exception.backtrace : 'exception missing')
    LogWrapper.log('ERROR', {
      'message' => "#{message}...\nBacktrace=#{backtrace}.",
      'method' => method
    })
  end
  
  def api_response_builder(http_status, http_response=nil)
    render status: http_status, json: http_response
  end
end
