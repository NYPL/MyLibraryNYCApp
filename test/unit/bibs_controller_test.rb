# frozen_string_literal: true

require 'test_helper'

class BibsControllerTest < MiniTest::Test
  extend Minitest::Spec::DSL
  include LogWrapper

  def setup
    @controller = Api::V01::BibsController.new
    @mintest_mock1 = MiniTest::Mock.new
    @mintest_mock2 = MiniTest::Mock.new
    @mintest_mock3 = MiniTest::Mock.new
    @mintest_mock4 = MiniTest::Mock.new
    @teacher_set = TeacherSet.new(bnumber: 998)
  end

  

  # Delete teacher sets from teacher_set table
  describe "delete teacher sets by bibid" do
    # Case: 1
    # Delete teacher sets from teacher_set table
    it 'test delete teacher sets' do
      resp = nil
      teacherset_resp = TeacherSet.new(id: 733, bnumber: 998, title: "QA Teacher Set for MLN-662  AC#4")
      @mintest_mock1.expect(:call, [])
      @controller.instance_variable_set(:@request_body, req_body_for_item)
      @mintest_mock2.expect(:get_teacher_set_by_bnumber, teacherset_resp, ['998'])
      @mintest_mock3.expect(:feature_flag_config, false, ['teacherset.data.from.elasticsearch.enabled'])

      @controller.stub :validate_request, @mintest_mock1 do
        TeacherSet.stub :new, @mintest_mock2 do
          MlnConfigurationController.stub :new, @mintest_mock3 do
            @controller.stub :api_response_builder, delete_teacher_set_response, [] do
              resp = @controller.delete_teacher_sets
            end
          end
        end
      end
      assert_equal(delete_teacher_set_response, resp)
      @mintest_mock1.verify
      @mintest_mock2.verify
      @mintest_mock3.verify
    end

    # Case: 2
    # If feature flag is enabled than delete teacher-set document from elasticsearch.
    # Feature flag: 'teacherset.data.from.elasticsearch.enabled = true'.
    it 'test delete teacher sets from es' do
      resp = nil
      teacherset_resp = TeacherSet.new(id: 733, bnumber: 998, title: "QA Teacher Set for MLN-662  AC#4")
      @mintest_mock1.expect(:call, [])
      @controller.instance_variable_set(:@request_body, req_body_for_item)
      @mintest_mock2.expect(:get_teacher_set_by_bnumber, teacherset_resp, ['998'])
      @mintest_mock3.expect(:feature_flag_config, true, ['teacherset.data.from.elasticsearch.enabled'])
      @mintest_mock4.expect(:call, true, [teacherset_resp.id])

      @controller.stub :validate_request, @mintest_mock1 do
        TeacherSet.stub :new, @mintest_mock2 do
          MlnConfigurationController.stub :new, @mintest_mock3 do
            @controller.stub :delete_teacherset_record_from_es, @mintest_mock4 do
              @controller.stub :api_response_builder, delete_teacher_set_response, [] do
                resp = @controller.delete_teacher_sets
              end
            end
          end
        end
      end
      assert_equal(delete_teacher_set_response, resp)
      @mintest_mock1.verify
      @mintest_mock2.verify
      @mintest_mock3.verify
      @mintest_mock4.verify
    end

    # Case: 3
    # Test if Teacherset record not found in database return nil
    it 'test delete teacher sets from es' do
      resp = nil
      teacherset_resp = nil
      @mintest_mock1.expect(:call, [])
      @controller.instance_variable_set(:@request_body, req_body_for_item)
      @mintest_mock2.expect(:get_teacher_set_by_bnumber, teacherset_resp, ['998'])

      @controller.stub :validate_request, @mintest_mock1 do
        TeacherSet.stub :new, @mintest_mock2 do
          @controller.stub :api_response_builder, "{\"teacher_sets\":[]}", [] do
            resp = @controller.delete_teacher_sets
          end
        end
      end
      assert_equal("{\"teacher_sets\":[]}", resp)
      @mintest_mock1.verify
      @mintest_mock2.verify
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

  def delete_teacher_set_response
    { "teacher_sets": [{ "id": 733, "bnumber": "b998", "title": "QA Teacher Set for MLN-662  AC#4" }] }
  end
end
