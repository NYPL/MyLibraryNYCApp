# frozen_string_literal: true

require 'test_helper'

class BibsControllerTest < MiniTest::Test
  extend Minitest::Spec::DSL
  include LogWrapper

  def setup
    @controller = Api::V01::BibsController.new
    @mintest_mock1 = MiniTest::Mock.new
    @mintest_mock2 = MiniTest::Mock.new
    @teacher_set = TeacherSet.new(bnumber: 998)
  end

  # Feature flag: 'teacherset.data.from.elasticsearch.enabled = true'.
  # If feature flag is enabled delete data from elasticsearch.
  describe "delete teacher sets" do
    it 'test delete teacher sets' do
      @mintest_mock1.expect(:call, [])
      @controller.instance_variable_set(:@request_body, req_body_for_item)
      resp = nil
      expected_resp = "{\"teacher_sets\":[]}"
      TeacherSet.stub :new, TeacherSet.new(bnumber: 'b998') do
        @controller.stub :validate_request, @mintest_mock1 do
          @controller.stub :api_response_builder, expected_resp, [] do
            resp = @controller.delete_teacher_sets
          end
        end
      end
      assert_equal(expected_resp, resp)
      @mintest_mock1.verify
    end
  end


  private

  def req_body_for_item
    [{
      'nyplSource' => 'sierra-nypl',
      'id' => '998',
      'bibIds' => [
        '998'
      ],
      'status' => {
        'code' => '-', 
        'display' => 'AVAILABLE', 
        'duedate' => '2011-04-26T16:16:00-04:00'
      }
    }]
  end
end
