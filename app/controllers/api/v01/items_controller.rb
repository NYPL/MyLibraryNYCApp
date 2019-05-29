class Api::V01::ItemsController < Api::V01::GeneralController
  include LogWrapper

  before_filter :set_request_body
  before_filter :validate_source_of_request

  # Updates the available_copies, total_copies, and availability fields on a teacher_set.
  # Receives a list of items from a POST request, each item represented by a JSON record.
  # All records are inside @request_body.
  # Parses the item bodies to retrieve the bib id.  For each valid item, sends a request to the Bib Service for all of the items belonging to that bib.
  # For each item in the returned list, parses the JSON body, to retrieve the due_date.  If the due_date is not null, counts the item as "unavailable".  
  # Adds up the total number of items, and the number of items available, and updates the teacher_set fields accordingly.
  # On error finding local data, writes a message to the error log, but returns a success to the calling lambda.  
  # On error communicating with the Bib Service, returns a failure to the calling lambda (triggering a re-try).
  def update_availability
    begin
      http_status = 200
      LogWrapper.log('DEBUG', {'message' => 'update_availability.start','method' => "#{controller_name}.#{action_name}"})
      error_code_and_message = validate_request
      if error_code_and_message.any?
        AdminMailer.failed_items_controller_api_request(@request_body, error_code_and_message, action_name).deliver
        render_error(error_code_and_message)
      end
      return if error_code_and_message.any?
      # total_count, available_count, t_set_bnumber = fetch_items_available_and_total_count
      
      # unless t_set_bnumber.present?
      #   render_error([404, "bibIds are empty."]) 
      #   return
      # end
      # teacher_set = TeacherSet.find_by_bnumber("b#{t_set_bnumber}")
      # unless teacher_set.present?
      #   render_error([404, "bibIds are not found in MLN DB."])
      #   return
      # end 
      # teacher_set.update_available_and_total_count(total_count, available_count)
      http_response = {items: 'OK'}
      LogWrapper.log('INFO','message' => "Items availability successfully updated")
      api_response_builder(http_status, http_response)
    rescue => exception
      log_error('update_availability', exception)
    end
  end #method ends

  #Fetching available,total count and t_set_bnumber.
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
