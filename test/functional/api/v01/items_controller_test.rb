# frozen_string_literal: true

require 'test_helper'

class Api::ItemsControllerTest < MiniTest::Test

  extend Minitest::Spec::DSL
  include LogWrapper

  before do
    @controller = Api::V01::ItemsController.new
    @mintest_mock1 = MiniTest::Mock.new
    @mintest_mock2 = MiniTest::Mock.new
  end

  # Update availability method parses the item bodies to retrieve the bib id.
  # TEST1: Bib id not present in item body raise the bnumber not found in MLN db.
  describe '#test update availability method' do
    it 'test error message for update availability; bnumber not found in MLN db' do
      resp = nil
      error_message = [404, "BIB id is empty."]
      @mintest_mock1.expect(:call, nil)
      total_count = 6
      available_count = 5
      t_set_bnumber = '21480355'
      nypl_source = 'sierra-nypl'
      @mintest_mock2.expect(:call, [nil, nypl_source], [bibid_missing_req_body_for_item])
      @controller.stub :validate_request, @mintest_mock1 do
        @controller.stub :parse_item_bib_id_and_nypl_source, @mintest_mock2 do
          @controller.stub :render_error, [error_message[0], error_message[1]], [error_message] do
            resp = @controller.update_availability
          end
        end
      end
      assert_nil(resp)
      @mintest_mock1.verify
    end

    # Update availability method missing the item bodies.
    # TEST2: IF Request body is missing test parsing error message.
    it 'test parsing error for update availability method' do
      error_message = [400, "Parsing error: 765: unexpected token at ''"]
      error_resp = [status: error_message[0], json: { message: error_message[1]}]
      resp = nil
      mail_resp = OpenStruct.new(Message: '123', Multipart: false)
      @mintest_mock1.expect(:call, error_message)
      @controller.stub :validate_request, @mintest_mock1 do
        AdminMailer.stub :failed_items_controller_api_request, mail_resp, [{"test1": "test2"}, error_message, 'update_availability'] do
          @controller.stub :render_error, [error_message[0], error_message[1]], [error_message] do
            resp = @controller.update_availability
          end
        end
      end
      assert_nil(resp)
      @mintest_mock1.verify
    end
  end

  # Reads item JSON, Parses out the item t_set_bnumber and nypl_source
  describe '#parse req body item bibid and nypl_source method' do
    it 'test parse bibid and nypl source' do
      resp = @controller.parse_item_bib_id_and_nypl_source(req_body_for_item)
      bib_id = '21480355'
      nypl_source = 'sierra-nypl'
      assert_equal(resp[0], bib_id)
      assert_equal(resp[1], nypl_source)
    end
  end

  private

  def req_body_for_item
    { 'data' => [ {
          'nyplSource' => 'sierra-nypl', 
          'bibIds' => [
            '21480355'
          ],
          'status' => {
            'code' => '-', 
            'display' => 'AVAILABLE', 
            'duedate' => '2011-04-26T16:16:00-04:00'
          },
        } ],
      'count' => 1,
      'totalCount' => 1,
      'statusCode' => 200,
      'debugInfo' => []
    }
  end


  def bibid_missing_req_body_for_item
    { 'data' => [ {
          'nyplSource' => 'sierra-nypl', 
          'bibIds' => [],
          'status' => {
            'code' => '-', 
            'display' => 'AVAILABLE', 
            'duedate' => '2011-04-26T16:16:00-04:00'
          },
        } ],
      'count' => 1,
      'totalCount' => 1,
      'statusCode' => 200,
      'debugInfo' => []
    }
  end
end
