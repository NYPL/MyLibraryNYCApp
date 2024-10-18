# frozen_string_literal: true

require 'test_helper'
class BookUnitTest < Minitest::Test

  extend Minitest::Spec::DSL
  include LogWrapper

  def setup
    @book_model = Book.new
    @mintest_mock1 = Minitest::Mock.new
    @mintest_mock2 = Minitest::Mock.new
  end

  def test_bib_service_response_failure_case
    @book_model.instance_variable_set(:@book_found, false)
    expected_resp = nil
    @mintest_mock1.expect(:call, [expected_resp])
    response = nil
    @book_model.stub :send_request_to_bibs_microservice, @mintest_mock1 do
      response = @book_model.update_from_isbn
    end
    @mintest_mock1.verify
    assert_nil(nil, response)
  end

  def test_bib_service_response_success_case
    @book_model.instance_variable_set(:@book_found, true)
    expected_resp = Struct.new(:body, :code).new(MODIFIED_BOOK_JSON_FOR_ISBN_9782917623268, 200)

    @mintest_mock1.expect(:call, expected_resp)
    response = nil
    @book_model.stub :send_request_to_bibs_microservice, @mintest_mock1 do
      response = @book_model.update_from_isbn
    end
    @mintest_mock1.verify
    assert_equal(true, response)
  end


  # This method returns Fixed Field values from bib response
  # eg: book_attributes = "fixedFields" => {"24" => {"label" => "Language", "value" => "eng", "display" => "English"}
  # Return result value = "English"
  describe 'test bib response fixed field method' do
    it 'Test fixed field display value' do
      book_attributes =  {"fixedFields" => {"24" => {"label" => "Language", "value" => "eng", "display" => "English"}}}
      response = @book_model.send(:fixed_field, book_attributes, '24')
      assert_equal("English", response)
    end

    it 'Test fixed field value' do
      book_attributes =  {"fixedFields" => {"24" => {"label" => "Language", "value" => "eng", "display" => "English"}}}
      response = @book_model.send(:fixed_field, book_attributes, '24', true)
      assert_equal("eng", response)
    end
  end
end
