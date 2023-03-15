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
      resp = @controller.set_request_body
      assert_equal(resp.class, NoMethodError)
    end
  end

  describe '#render_error' do
    it 'test render error' do
      resp = nil
      error_message = [400, 'error message']
      exp_output = {status: error_message[0], json: error_message[1]}
      @mintest_mock1.expect(:call, exp_output, [error_message[0], error_message[1]])
      @controller.stub :api_response_builder, @mintest_mock1 do
        resp = @controller.render_error(error_message)
      end
      assert_equal(error_message[0], resp[:status])
      assert_equal(error_message[1], resp[:json])
    end
  end

  describe '#validate request' do
    it 'test validate request' do
      resp = @controller.validate_request
      expected_resp = [400, "Request body is empty."]
      assert_equal(expected_resp[0], resp[0])
      assert_equal(expected_resp[1], resp[1])
    end
  end

  describe '#log error' do
    it 'test log error' do
      exception = OpenStruct.new(message: 'error occured', backtrace: 'error' ) 
      resp = @controller.log_error(__method__, exception)
      assert(resp)
    end
  end
end