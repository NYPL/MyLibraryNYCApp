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
      return error_code_and_message if error_code_and_message.any?
      total_count, available_count, teacher_set_id = fetch_items_available_and_total_count
      render_error([404, "bibIds are empty."]) unless teacher_set_id.present?
      teacher_set = TeacherSet.find_by_id(teacher_set_id)
      teacher_set.update_available_and_total_count(total_count, available_count)
      http_response = {items: 'OK'}
      LogWrapper.log('INFO','message' => "Items availability successfully updated")
      api_response_builder(http_status, http_response)
    rescue => exception
      log_error('update_availability', exception)
    end
  end

  def fetch_items_available_and_total_count
    availble_count = 0
    total_count  = 0
    teacher_set_id = nil
    @request_body['data'].each do |item|
      total_count += 1
      availble_count += 1 unless item['status']['duedate'].present?
      teacher_set_id = item['bibIds'].join 
    end
    LogWrapper.log('INFO','message' => "TeacherSet availble_count: #{availble_count}, total_count: #{total_count}")
    return total_count, availble_count, teacher_set_id
  end
end
