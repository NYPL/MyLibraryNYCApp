# frozen_string_literal: true

require 'test_helper'

class Api::GeneralControllerTest < Minitest::Test

  extend Minitest::Spec::DSL
  include LogWrapper

  before do
    @controller = Api::V01::GeneralController.new
    @mintest_mock1 = Minitest::Mock.new
    body = StringIO.new
    body.puts "#{{:test=>"test1"}}"
    @request = Struct.new(:key, :body).new('1234', body)
  end


  describe '#test set_request_body' do
    it 'test request body' do
      resp = @controller.send(:set_request_body)
      assert_equal(resp.class, NoMethodError)
    end
  end

  describe '#render_error' do
    it 'test render error' do
      resp = nil
      error_message = [400, 'error message']
      exp_output = { status: error_message[0], json: error_message[1] }.to_json
      exp_input = [400, "{\"message\":\"error message\"}"]
      @mintest_mock1.expect(:call, exp_output, exp_input)
      @controller.stub :api_response_builder, @mintest_mock1 do
        resp = @controller.send(:render_error, error_message)
      end
      assert_equal(error_message[0], JSON.parse(resp)['status'])
      assert_equal(error_message[1], JSON.parse(resp)['json'])
    end
  end

  describe '#validate request' do
    it 'test validate request' do
      resp = @controller.send(:validate_request)
      expected_resp = [400, "Request body is empty."]
      assert_equal(expected_resp[0], resp[0])
      assert_equal(expected_resp[1], resp[1])
    end
  end

  describe '#log error' do
    it 'test log error' do
      exception = Struct.new(:message, :backtrace).new('error occured', 'error')
      resp = @controller.send(:log_error, __method__, exception)
      assert_equal(true, resp)
    end
  end
end
