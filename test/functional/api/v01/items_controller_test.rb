# frozen_string_literal: true

require "test_helper"

class ItemsControllerTest < ActionController::TestCase
  def setup
    # Explicitly set the controller to avoid the 'nil' error
    @controller = Api::V01::ItemsController.new

    @request_body = [{
      "nyplSource" => "sierra-nypl",
      "bibIds" => ["998"],
      "status" => {
        "code" => "-",
        "display" => "AVAILABLE",
        "duedate" => "2011-04-26T16:16:00-04:00",
      },
    }]

    @valid_teacher_set = TeacherSet.new(bnumber: "b998")
  end

  test "should update availability successfully" do
    @controller.stub :parse_request_body, req_body_for_item do
      TeacherSet.stub :find_by_bnumber, @valid_teacher_set do
        @valid_teacher_set.stub :update_available_and_total_count, true do
          post :update_availability, params: { items: @request_body }

          assert_response :success
          response_body = JSON.parse(@response.body)
          assert_equal "OK", response_body["items"].first["response"]["message"]
        end
      end
    end
  end

  # test "Bib id is empty" do
  #   @controller.stub :parse_request_body, req_body_for_item do
  #     @valid_teacher_set.stub :update_available_and_total_count, true do
  #       post :update_availability, params: { items: @request_body }

  #       assert_response :success
  #       response_body = JSON.parse(@response.body)
  #       assert_equal 404, response_body["items"][0]["status"]
  #     end
  #   end
  # end

  test "NYPL source is empty" do
    @request_body = [{
      "nyplSource" => "",
      "bibIds" => ["998"],
      "status" => {
        "code" => "-",
        "display" => "AVAILABLE",
        "duedate" => "2011-04-26T16:16:00-04:00",
      },
    }]

    @controller.stub :parse_request_body, @request_body do
      TeacherSet.stub :find_by_bnumber, @valid_teacher_set do
        @valid_teacher_set.stub :update_available_and_total_count, true do
          post :update_availability, params: { items: "" }

          assert_response :success
          response_body = JSON.parse(@response.body)
          assert_equal 400, response_body["items"][0]["status"]
        end
      end
    end
  end

  # private
  def req_body_for_item
    [{
      "nyplSource" => "sierra-nypl",
      "bibIds" => [
        "998",
      ],
      "id": "38991253",
      "status" => {
        "code" => "-",
        "display" => "AVAILABLE",
        "duedate" => "2011-04-26T16:16:00-04:00",
      },
    }]
  end
end
