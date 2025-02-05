# frozen_string_literal: true

class Api::V01::ItemsController < Api::V01::GeneralController
  include LogWrapper
  include MlnHelper
  include MlnResponse

  before_action :set_request_body
  before_action :validate_source_of_request

  # Updates the available_copies, total_copies, and availability fields on a teacher_set.
  # Receives a list of items from a POST request, each item represented by a JSON record.
  # All records are inside @request_body.
  # Parses the item bodies to retrieve the bib id.
  # For each valid item, sends a request to the Bib Service for all of the items belonging to that bib.
  # For each item in the returned list, parses the JSON body, to retrieve the due_date.  If the due_date is not null,
  # counts the item as "unavailable".
  # Adds up the total number of items, and the number of items available, and updates the teacher_set fields accordingly.
  # On error finding local data, writes a message to the error log, but returns a success to the calling lambda.
  # On error communicating with the Bib Service, returns a failure to the calling lambda (triggering a re-try).
  def update_availability
    api_response = []
    begin
      parse_request_body(request).each do |req_body|
        begin
          LogWrapper.log("DEBUG", { "message" => "update_availability.start", "method" => "#{controller_name}.#{action_name}",
                                    "requestBody" => req_body })
          error_code_and_message = validate_request
          if error_code_and_message.any?
          end
          t_set_bnumber, nypl_source = parse_item_bib_id_and_nypl_source(req_body)
          http_status = 200
          unless t_set_bnumber.present?
            http_status = 404
            message = "BIB id is empty."
            http_response = SYS_FAILURE.call(http_status, message, "Item id: #{req_body["id"]}")
            api_response << { status: http_status, response: http_response }
          end

          unless nypl_source.present?
            http_status = 400
            message = "NYPL source is empty."
            http_response = SYS_FAILURE.call(http_status, message, "Item id: #{req_body["id"]}")
            api_response << { status: http_status, response: http_response }
          end

          teacher_set = TeacherSet.find_by_bnumber("b#{t_set_bnumber}")
          unless teacher_set.present?
            http_status = 404
            message = "BIB id not found in MLN DB. Bib id b#{t_set_bnumber},"
            http_response = SYS_FAILURE.call(http_status, message, "Item id: #{req_body["id"]}")
          end
          if teacher_set.present? && t_set_bnumber.present?
            teacher_set.update_available_and_total_count(t_set_bnumber)
            http_response = { message: "OK" }
            message = "Items availability successfully updated. Bnumber: #{t_set_bnumber}"
          end
        rescue InvalidInputException => e
          http_status = 400
          message = e.message
          response = SYS_FAILURE.call(e.code, e.message, e.detailed_msg, "Item id: #{req_body["id"]}")
        rescue StandardError => e
          http_status = 500
          http_response = "Error while getting item records via API: #{e.message[0..200]}, Bnumber: #{t_set_bnumber}"
          AdminMailer.failed_items_controller_api_request(http_response).deliver
          api_response << { status: http_status, response: http_response }
        end
        LogWrapper.log("INFO", { "message" => "message: #{message}, http_status: #{http_status}",
                                 "method" => __method__, "item_id" => req_body["id"] })
        api_response << { status: http_status, response: http_response }
      end
    rescue InvalidInputException => e
      http_status = 400
      message = e.message
      http_response = SYS_FAILURE.call(e.code, e.message, e.detailed_msg)
      api_response << { status: http_status, response: http_response }
    end
    # HTTP status code 200 was specifically added for the consumer app to ensure proper handling of API responses.
    api_http_status = api_response.pluck(:status).include?(500) ? 500 : 200
    render status: api_http_status, json: api_response
  end #method ends

  # All records are inside @request_body.
  # Reads item JSON, Parses out the item t_set_bnumber and nypl_source
  def parse_item_bib_id_and_nypl_source(request_body)
    t_set_bnumber = nil
    nypl_source = nil
    t_set_bnumber = request_body["bibIds"][0]
    nypl_source = request_body["nyplSource"]
    return t_set_bnumber, nypl_source
  end
end
