# frozen_string_literal: true

require 'test_helper'

class Api::GeneralControllerTest < MiniTest::Test

  extend Minitest::Spec::DSL
  include LogWrapper

  before do
    @controller = Api::V01::GeneralController.new
    @mintest_mock1 = MiniTest::Mock.new
    body = StringIO.new
    body.puts "#{{:test=>"test1"}}"
    @request = OpenStruct.new(key: '1234', body: body )
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
      error_message = [400, 'Request body is empty.']
      exp_output = "{\"message\":\"Request body is empty.\"}"
      @mintest_mock1.expect(:call, exp_output, [error_message[0], {message: error_message[1]}.to_json])
      @controller.stub :api_response_builder, @mintest_mock1 do
        resp = @controller.send(:render_error, error_message)
      end
      assert_equal(error_message[1], JSON.parse(resp)["message"])
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
    it 'test log error method' do
      exception = OpenStruct.new(message: 'error occured', backtrace: 'error' ) 
      resp = @controller.send(:log_error, 'log_error', exception)
      assert_equal(129, resp)
    end
  end

  # An exponential backoff algorithm retries requests exponentially, 
  # increasing the waiting time between retries up to a maximum backoff time
  describe 'test exponential backoff method' do
    it 'test exponential backoff' do
      resp = @controller.send(:exponential_backoff_in_sec, 1)
      assert_equal(5, resp)
    end
  end
end