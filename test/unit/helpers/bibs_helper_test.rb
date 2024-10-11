# frozen_string_literal: true

require 'test_helper'

class BibsHelperTest < Minitest::Test
  extend Minitest::Spec::DSL
  include LogWrapper
  include BibsHelper
  include MlnResponse
  include MlnHelper

  def setup
    @mintest_mock1 = Minitest::Mock.new
    @mintest_mock2 = Minitest::Mock.new
  end


  # test teacher set object method.
  describe "validate_input_params" do
    it 'bib id not present in request body' do
      req_body = SIERRA_USER['data'][0]
      req_body['title'] = "test"
      req_body['id'] = ''

      exp_resp = { value: req_body['id'], error_msg: BIB_NUMBER_EMPTY[:msg]}

      resp = assert_raises(InvalidInputException) do
        validate_input_params(req_body)
      end
      assert_equal(resp.detailed_msg, exp_resp[:error_msg])
    end


    it 'title not present in request body' do
      req_body = SIERRA_USER['data'][0]
      req_body['id'] = "7899158"
      req_body['title'] = ''

      exp_resp = { value: req_body['title'], error_msg: TITLE_EMPTY[:msg]}

      resp = assert_raises(InvalidInputException) do
        validate_input_params(req_body, true)
      end
      assert_equal(resp.detailed_msg, exp_resp[:error_msg])
    end
  end


  describe 'test api bib_response' do
    it 'test api bib response method' do
      t_set = Struct.new(:bnumber, :id, :title).new(123, 1, "23")
      resp = bib_response(t_set)
      assert_equal(t_set.id, resp[:id])
      assert_equal(t_set.bnumber, resp[:bnumber])
      assert_equal(t_set.title, resp[:title])
    end
  end

  describe 'read var field value' do
    it 'test var field method' do
      req_body = SIERRA_USER['data'][0]
      assert_equal('physical desc', var_field(req_body, '300'))
    end
  end
end
