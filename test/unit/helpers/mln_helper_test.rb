# frozen_string_literal: true

require 'test_helper'

class MlnHelperTest < Minitest::Test
  extend Minitest::Spec::DSL
  include LogWrapper
  include MlnResponse
  include MlnException
  include MlnHelper

  describe 'validate input params' do
    it 'validate empty value' do
      input_params = [{ value: [], error_msg: BIB_NUMBER_EMPTY[:msg]}]
      resp = assert_raises(InvalidInputException) do
        validate_empty_values(input_params)
      end
      assert_equal(INVALID_INPUT[:code], resp.code)
      assert_equal(INVALID_INPUT[:msg], resp.message)
    end

    it 'test validate json ' do
      str = {data: 123}.to_json
      resp = json_valid?(str)
      assert_equal(true, resp)
    end
  end
end
