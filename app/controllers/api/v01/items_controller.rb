class Api::V01::ItemsController < Api::V01::GeneralController
  include LogWrapper

  before_filter :set_request_body
  before_filter :validate_source_of_request

  #Here Updating the available_copies, total copies in Teacher Set table.
  def update_availability
    begin
      http_status = 200
      error_code_and_message = validate_request
      if error_code_and_message.any?
        AdminMailer.failed_items_controller_api_request(@request_body, error_code_and_message, action_name).deliver
        render_error(error_code_and_message)
      end
      total_count, available_count, t_set_bnumber = fetch_items_available_and_total_count
      render_error([404, "bibIds are empty."]) unless t_set_bnumber.present?
      teacher_set = TeacherSet.find_by_bnumber("b#{t_set_bnumber}") 
      render_error([404, "bibIds are not found in MLN DB."]) unless teacher_set.present?
      teacher_set.update_available_and_total_count(total_count, available_count)
      http_response = {items: 'OK'}
      LogWrapper.log('INFO','message' => "Items availability successfully updated")
      api_response_builder(http_status, http_response)
    rescue => exception
      log_error('update_availability', exception)
    end
  end

  #Parsing the json, fetching the available,total count and t_set_bnumber.
  def fetch_items_available_and_total_count
    availble_count = 0
    total_count  = 0
    t_set_bnumber = nil
    @request_body['data'].each do |item|
      total_count += 1
      availble_count += 1 unless item['status']['duedate'].present?
      t_set_bnumber = item['bibIds'].join 
    end
    LogWrapper.log('INFO','message' => "TeacherSet availble_count: #{availble_count}, total_count: #{total_count}")
    return total_count, availble_count, t_set_bnumber
  end
end
