# frozen_string_literal: true

require 'test_helper'

class Api::BibsControllerTest < ActiveSupport::TestCase
  extend Minitest::Spec::DSL

  before do
    @mintest_mock1 = MiniTest::Mock.new
    @controller = Api::V01::BibsController.new
  end

  describe 'create_or_update_teacher_sets with 400 response' do
    it 'respond with 400 if request body is missing' do
      error_message = [400, "Parsing error: 765: unexpected token at ''"]
      @mintest_mock1.expect(:call, error_message)
      resp = nil
      mail_resp = OpenStruct.new(Message: '123', Multipart: false)
      AdminMailer.stub :failed_items_controller_api_request, mail_resp, [{"test1": "test2"}, error_message, 'update_availability'] do
        @controller.stub :render_error, [error_message[0], error_message[1]], [error_message] do
          @controller.stub :validate_request, @mintest_mock1 do
            resp = @controller.create_or_update_teacher_sets
          end
        end
      end
      assert_nil(resp)
      @mintest_mock1.verify
    end
  end

  describe 'test create_or_update_teacher_sets with 200 response' do
    it 'respond with 200 if request body is present' do
      @request_body = {"22" => '333'}
      teacherset_obj = OpenStruct.new(id: '998')
      @controller.instance_variable_set(:@request_body, bib_api_request_body)
      @mintest_mock1.expect(:call, [])
      resp = nil
      data = {status: 200, json: { teacher_sets: ['data'] }.to_json}

      @controller.stub :api_response_builder, data, [200, { teacher_sets: ['data'] }] do
        TeacherSet.stub :first_or_initialize, teacherset_obj do
          @controller.stub :validate_request, @mintest_mock1 do
            resp = @controller.create_or_update_teacher_sets
          end
        end
      end
      assert_equal(resp, data)
      @mintest_mock1.verify
    end
  end

  describe 'test get grades' do
    it 'get grades' do
      grade_and_lexile_json = ["9", "114-4", "Z", "1130L"]
      resp = @controller.send(:get_grades, grade_and_lexile_json)
      assert_equal(resp, [grade_and_lexile_json[0]])
    end
  end

  describe 'test delete teacher_sets' do
    it 'delete teacher_sets error message' do
      error_message = [400, "Parsing error: 765: unexpected token at ''"]
      @mintest_mock1.expect(:call, error_message)
      resp = nil
      mail_resp = OpenStruct.new(Message: '123', Multipart: false)
      AdminMailer.stub :failed_bibs_controller_api_request, mail_resp, [{"test1": "test2"}, error_message, 'update_availability'] do
        @controller.stub :render_error, [error_message[0], error_message[1]], [error_message] do
          @controller.stub :validate_request, @mintest_mock1 do
            resp = @controller.delete_teacher_sets
          end
        end
      end
      assert_nil(resp)
      @mintest_mock1.verify
    end

    it 'test delete teacher_sets success response' do
      data = {status: 200, json: { teacher_sets: ['data'] }.to_json}
      @mintest_mock1.expect(:call, [])
      @controller.instance_variable_set(:@request_body, bib_api_request_body)
      teacherset_obj = OpenStruct.new(id: '998')
      resp = nil
      @controller.stub :api_response_builder, data, [200, { teacher_sets: ['data'] }] do
        @controller.stub :validate_request, @mintest_mock1 do
          TeacherSet.stub :new, teacherset_obj do
            resp = @controller.delete_teacher_sets
          end
        end
      end
      assert_equal(resp, data)
      @mintest_mock1.verify
    end
  end

  private

  def bib_api_request_body
    [ONE_TEACHER_SET_WITH_A_BOOK_ISBN_OF_300_CHARACTERS[0].stringify_keys]
  end
end


