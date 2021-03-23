# frozen_string_literal: true

class Api::V01::BibsController < Api::V01::GeneralController
  include LogWrapper
  include MlnException
  include MlnResponse
  include MlnHelper
  include BibService

  before_action :set_request_body
  before_action :validate_source_of_request

  # Receive teacher sets from a POST request.
  # Find or create a teacher set in the MLN db and its associated books.
  def create_or_update_teacher_sets
    LogWrapper.log('DEBUG', {'message' => 'create_or_update_teacher_sets.start','method' => 'bibs_controller.create_or_update_teacher_sets'})
    http_status = 200
    req_body = parse_request_body(request)[0]
    bnumber = req_body['id']
    title = req_body['title']
    physical_description = var_field('300', req_body)

    # validate req body input params
    validate_input_params(bnumber, title, physical_description, true)

    # Call bib service method to create/update teacher-set information.
    teacher_set = create_or_update_teacher_set_data(req_body)
    response = SYS_SUCCESS.call('TeacherSet successlly created', { teacher_set: bib_response(teacher_set) }.to_json)
  rescue InvalidInputException => e
    http_status = 400
    message = e.message
    response = SYS_FAILURE.call(e.code, e.message)
  rescue DBException, ElasticsearchException => e
    http_status = 500
    message = e.message
    response = SYS_FAILURE.call(e.code, e.message)
  rescue StandardError => e
    http_status = 500
    message = e.message
    response = SYS_FAILURE.call(UNEXPECTED_EXCEPTION[:code], UNEXPECTED_EXCEPTION[:msg])
    AdminMailer.failed_bibs_controller_api_request(
        req_body, "Error while updating the teacherset: #{e.message[0..200]}...", action_name, teacher_set
      ).deliver

    LogWrapper.log('INFO', {'message' => "message: #{message}, http_status: #{http_status}",
                            'method' => 'teacher_set.update_set_type'})
    api_response_builder(http_status, response)
  end


  def delete_teacher_sets
    http_status = 200
    req_body = parse_request_body(request)[0]
    bib_id = req_body['id']
    validate_input_params(bib_id)
    teacher_set = delete_teacher_set(bib_id)
    response = SYS_SUCCESS.call('TeacherSet successlly deleted', { teacher_set: bib_response(teacher_set) }.to_json)
  rescue InvalidInputException => e
    http_status = 400
    message = e.message
    response = SYS_FAILURE.call(e.code, e.message)
  rescue BibRecordNotFoundException => e
    http_status = 404
    message = e.message
    response = SYS_FAILURE.call(e.code, e.message)
  rescue DBException, ElasticsearchException => e
    http_status = 500
    message = e.message
    response = SYS_FAILURE.call(e.code, e.message)
  rescue StandardError => e
    http_status = 500
    message = e.message
    response = SYS_FAILURE.call(UNEXPECTED_EXCEPTION[:code], UNEXPECTED_EXCEPTION[:msg])
    AdminMailer.failed_bibs_controller_api_request(
        req_body, "Error while deleting the teacherset: #{e.message[0..200]}...", action_name, teacher_set
      ).deliver
    LogWrapper.log('INFO', {'message' => "message: #{message}, http_status: #{http_status}",
                            'method' => 'teacher_set.update_set_type'})
    
    api_response_builder(http_status, response)
  end

end
