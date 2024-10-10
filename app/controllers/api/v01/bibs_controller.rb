# frozen_string_literal: true

class Api::V01::BibsController < Api::V01::GeneralController
  include LogWrapper
  include MlnException
  include MlnResponse
  include MlnHelper
  include BibsHelper

  before_action :validate_source_of_request

  # Receive teacher sets from a POST request.
  # Find or create a teacher set in the MLN db and its associated books.
  def create_or_update_teacher_set
    api_response = []
    parse_request_body(request).each do |req_body|
      begin
        http_status = 200
        LogWrapper.log('DEBUG', {'message' => 'create_or_update_teacher_sets.start','method' => 'bibs_controller.create_or_update_teacher_sets'})
        # Raise validations if input params missing
        validate_input_params(req_body, true)

        # create/update teacher-set data from bib request_body.
        teacher_set = TeacherSet.create_or_update_teacher_set(req_body)
        response = SYS_SUCCESS.call('TeacherSet successlly created', { teacher_set: bib_response(teacher_set) }.to_json)
        ts_id = teacher_set.id
      rescue InvalidInputException => e
        http_status = 400
        message = e.message
        response = SYS_FAILURE.call(e.code, e.message, e.detailed_msg)
      rescue SuppressedBibRecordException, BibRecordNotFoundException => e
        http_status = 404
        message = e.message
        response = SYS_FAILURE.call(e.code, e.message, e.detailed_msg)
      rescue DBException, ElasticsearchException => e
        http_status = 500
        message = e.message
        response = SYS_FAILURE.call(e.code, e.message, e.detailed_msg)
      rescue StandardError => e
        http_status = 500
        message = e.message
        response = SYS_FAILURE.call(UNEXPECTED_EXCEPTION[:code], UNEXPECTED_EXCEPTION[:msg])
        AdminMailer.failed_bibs_controller_api_request(req_body, "Error while creating/updating the teacherset: #{e.message[0..200]}...", 
                                                      action_name, teacher_set).deliver
      end
      LogWrapper.log('INFO', {'message' => "message: #{message}, http_status: #{http_status}",
      'method' => __method__, 'bib_id' => req_body['id'], 'teacher_set_id' => ts_id,
      'suppressed' => req_body["suppressed"]})
      api_response << { status: http_status, response: response }
    end
    api_http_status =  api_response.pluck(:status).include?(500) ? 500 : 200
    render status: api_http_status, json: api_response
  end

  def delete_teacher_set
    begin
      http_status = 200
      req_body = parse_request_body(request)[0]
      bib_id = req_body['id']

      # Raise validations if input params missing
      validate_input_params(req_body)

      # Delete teacher-set from db and elastic-search.
      teacher_set = TeacherSet.delete_teacher_set(bib_id)
      response = SYS_SUCCESS.call('TeacherSet successlly deleted', { teacher_set: bib_response(teacher_set) }.to_json)
      ts_id = teacher_set.id
    rescue InvalidInputException => e
      http_status = 400
      message = e.message
      response = SYS_FAILURE.call(e.code, e.message, e.detailed_msg)
    rescue BibRecordNotFoundException => e
      http_status = 404
      message = e.message
      response = SYS_FAILURE.call(e.code, e.message, e.detailed_msg)
    rescue DBException, ElasticsearchException => e
      http_status = 500
      message = e.message
      response = SYS_FAILURE.call(e.code, e.message, e.detailed_msg)
    rescue StandardError => e
      http_status = 500
      message = e.message
      response = SYS_FAILURE.call(UNEXPECTED_EXCEPTION[:code], UNEXPECTED_EXCEPTION[:msg])
      AdminMailer.failed_bibs_controller_api_request(req_body, "Error while deleting the teacherset: #{e.message[0..200]}...", 
                                                     action_name, teacher_set).deliver
    end
    LogWrapper.log('INFO', {message: "message: #{message}, http_status: #{http_status}",
                            method: __method__, bib_id: req_body['id'], teacher_set_id: ts_id,
                            suppressed: req_body["suppressed"]})
    
    api_response_builder(http_status, response)
  end

end
