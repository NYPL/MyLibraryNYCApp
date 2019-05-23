require 'test_helper'

class Api::ItemsControllerTest < MiniTest::Test

  extend Minitest::Spec::DSL
  include LogWrapper

  before do
    @controller = Api::V01::ItemsController.new
    @mintest_mock1 = MiniTest::Mock.new
    @general_controller = Api::V01::GeneralController.new
  end

  describe '#test update availability' do

    it 'test success resp for update availability' do
      resp = nil
      http_status = 200
      http_response = { items: 'OK'}
      @mintest_mock1.expect(:call, [nil])
      api_resp = {status: http_status, json: http_response}
      
      @controller.stub :validate_request, @mintest_mock1 do
        @controller.stub :api_response_builder, [api_resp], [http_status, http_response] do
          resp = @controller.update_availability
        end
      end
      assert_equal(resp[0][:json], http_response)
      @mintest_mock1.verify
    end

    it 'test error messages for update availability' do
      error_message = [400, "Parsing error: 765: unexpected token at ''"]
      error_resp = [status: error_message[0], json: { message: error_message[1]}]
      resp = nil
      mail_resp = OpenStruct.new(Message: '123', Multipart: false)
      @mintest_mock1.expect(:call, error_message)
      @controller.stub :validate_request, @mintest_mock1 do
        AdminMailer.stub :failed_items_controller_api_request, mail_resp, [{"test1": "test2"}, error_message, 'update_availability'] do
          @controller.stub :render_error, [error_message[0], error_message[1]], error_message do
            resp = @controller.update_availability
          end
        end
      end
      assert_equal(error_message[0], resp[0])
      assert_equal(error_message[1], resp[1])
      @mintest_mock1.verify
    end
  end
end
