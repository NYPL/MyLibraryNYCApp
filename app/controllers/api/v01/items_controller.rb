class Api::V01::ItemsController < Api::V01::GeneralController
  include LogWrapper

  before_filter :set_request_body
  before_filter :validate_source_of_request

  def update_availability
    begin
      http_status = 200
      error_code_and_message = validate_request
      if error_code_and_message.any?
        AdminMailer.failed_items_controller_api_request(@request_body, error_code_and_message, action_name).deliver
        render_error(error_code_and_message)
      end
      return if error_code_and_message.any?
      http_response = { items: 'OK'}
      api_response_builder(http_status, http_response)
    rescue => exception
      log_error('create_or_update_teacher_sets', exception)
    end
  end
end