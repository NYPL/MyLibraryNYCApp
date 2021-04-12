# frozen_string_literal: true

require 'test_helper'

class TeacherSetTest < ActiveSupport::TestCase

  extend Minitest::Spec::DSL
  include LogWrapper
  include MlnResponse
  include MlnException

  before do
    @user = holds(:hold1).user
    @hold1 = holds(:hold1)
    @hold2 = holds(:hold2)
    @teacher_set = teacher_sets(:teacher_set_one)
    @teacher_set2 = teacher_sets(:teacher_set_two)
    @teacher_set3 = teacher_sets(:teacher_set_three)
    @teacher_set4 = teacher_sets(:teacher_set_four)
    @teacher_set6 = teacher_sets(:teacher_set_six)
    @model = TeacherSet.new
    @mintest_mock1 = MiniTest::Mock.new
    @mintest_mock2 = MiniTest::Mock.new
    @elasticsearch_adapter_mock = Minitest::Mock.new
  end
  

  describe 'creating a teacher set does not create a version, because papertrail is turned off' do
    it 'test creating a teacher set does not create a version, because papertrail is turned off' do
      # we turn it off this way in app/admin/teacher_sets.rb for creating new sets via the admin dashboard
      teacher_set = crank!(:teacher_set)
      assert_equal(0, PaperTrail::Version.count)
    end
  end

  describe 'updating a teacher set creates a version' do
    it 'test updating a teacher set creates a version' do
      teacher_set = crank!(:teacher_set)

      teacher_set.update(title: 'Title2')
      assert_equal(1, PaperTrail::Version.count)
    end
  end

  #Calls Bibs service 
  #Calculates the total number of items and available items in the BIb service response
  describe 'test update available and total count method' do
    it 'test update available and total count' do
      bib_id = '21480355'
      nypl_source = 'sierra-nypl'
      @items_found = "ert"
      resp = nil
      total_count = 2 
      available_count = 2

      @mintest_mock1.expect(:call, [bib_items_response, true], [bib_id])
      @mintest_mock2.expect(:call, [total_count, available_count], [bib_items_response])

      @model.stub :send_request_to_items_microservice, @mintest_mock1 do
        @model.stub :parse_items_available_and_total_count, @mintest_mock2 do
          @model.stub :update, true, [total_copies: total_count, available_copies: available_count, availability: 'available'] do
            resp = @model.update_available_and_total_count(bib_id)
          end
        end
      end
      assert_equal(bib_items_response, resp[:bibs_resp]) 
    end

    #Test:2 Bibid is not found in bibs service
    it 'test Bibid is not found in bibs service' do
      bib_id = '21480355'
      nypl_source = 'sierra-nypl'
      @items_found = "ert"
      resp = nil
      total_count = 2 
      available_count = 2

      @mintest_mock1.expect(:call, [bib_id_not_found_response, false], [bib_id])

      @model.stub :send_request_to_items_microservice, @mintest_mock1 do
        resp = @model.update_available_and_total_count(bib_id)
      end
      assert_equal(bib_id_not_found_response, resp[:bibs_resp])
    end
  end
  
  # Parses out the items duedate, items code is '-' which determines if an item is available or not.
  # Calculates the total number of items in the list, the number of items that are
  # available to lend.

  describe "test items availability and total count method" do
    it "test items availability and total count" do
      total_count = 2 
      available_count = 1
      resp = @model.parse_items_available_and_total_count(bib_items_response)
      assert_equal(total_count, resp[0])
      assert_equal(available_count, resp[1])
    end
  end

  
  # case 1: {:fieldTag=>"n", :marcTag=>"526", :ind1=>"0", :ind2=>"", :content=>"null", :subfields=>[{:tag=>"a", :content=>"Topic Set"}]}
  # If subfields.content type is "Topic Set", set_type value  stored as 'multi' in teacher_sets table.
  # If subfields.content type is "Book Club Set" set_type value  stored as 'single' in teacher_sets table.
  # case 2: If it is not present in subfields.content, derive the set_type from the number of distinct books attached to a TeacherSet.
  # If teacher-set-books exactly 1, it's a Bookclub Set; else it's a Topic Set.
  describe "test get set_type value method" do
    it "Get set_type value " do
      set_type_val = "Topic Set."
      resp = @teacher_set4.derive_set_type(set_type_val)
      assert_equal("Topic Set", resp)
    end

    # Books count > 1
    it "Calculate set_type value based on the books count > 1" do
      set_type_val = "Topic Set"
      resp = @teacher_set.derive_set_type(nil)
      assert_equal("Topic Set", resp)
    end

    # Books count == 1
    it "Calculate set_type value based on the books count == 1" do
      set_type_val = "Book Club Set"
      resp = @teacher_set2.derive_set_type(nil)
      assert_equal(set_type_val, resp)
    end
  end

  describe "test teacher-set holds count" do
    # Test-1
    it "test current-user holds count with hold_id not nil" do
      @mintest_mock1.expect(:call, [@hold1], [@user, @hold1.id])
      resp = nil
      @model.stub :holds_for_user, @mintest_mock1 do
        resp = @teacher_set.holds_count_for_user(@user, @hold1.id)
      end
      assert_equal(2, resp)
    end

    # Test-2
    it "test current-user holds count with hold_id nil" do
      @mintest_mock1.expect(:call, [@hold1], [@user, nil])
      resp = nil
      @model.stub :holds_for_user, @mintest_mock1 do
        resp = @teacher_set.holds_count_for_user(@user, @hold1.id)
      end
      assert_equal(2, resp)
    end
  end

  describe 'holds for user' do
    # Test-1
    it 'test current-user is not present' do
      resp = @teacher_set.holds_for_user(nil, @hold1.id)
      assert_empty(resp)
    end

    # Test-2
    it 'test current-user holds with hold_id' do
      @mintest_mock1.expect(:call, [@hold1], [@user, @hold1.id])
      resp = nil
      @model.stub :ts_holds_by_user_and_hold_id, @mintest_mock1 do 
        resp = @teacher_set.holds_for_user(@user, @hold1.id)
      end
      assert_equal([@hold1], resp)
    end

  end

  describe 'test update_subjects method' do
    # Case: 1
    it 'test with empty subjects' do
      subject_name_array = []
      resp = @teacher_set.update_subjects_via_api(subject_name_array)
      assert_nil(resp)
    end

    # Case: 2
    it 'update subjects' do
      subject_one = subjects(:subjects_one)
      subject_two = subjects(:subjects_two)
      subject_name_array = ["Authors, Russiantest", "Social"]
      resp = @teacher_set.update_subjects_via_api(subject_name_array)
      assert_equal(subject_one.id, resp[0])
      assert_equal(subject_two.id, resp[1])
    end
  end


  describe 'test bib record not found exception' do
    it 'test bib record not found exception' do
      bib_id = '000'
      resp = nil

      resp = assert_raises(BibRecordNotFoundException) do
        TeacherSet.delete_teacher_set(bib_id)
      end
      assert_equal(BIB_RECORD_NOT_FOUND[:code], resp.code)
      assert_equal(BIB_RECORD_NOT_FOUND[:msg], resp.message)
    end
  end

  def test_teacher_set_query
    params = {"page"=>"1", "controller"=>"teacher_sets", "action"=>"index", "format"=>"json"}
    resp = TeacherSet.for_query(params)
    assert_equal(6, resp.count)
  end


  # Update teacher-set document in ES
  describe '#test create or update teacherset' do

    it 'raises ElasticsearchException when ElasticSearch raises StandardError' do
      resp = nil
      detail_msg = 'exception occured'
      @elasticsearch_adapter_mock.expect(:update_document_by_id, nil) do
        raise StandardError, detail_msg
      end
    
      resp = assert_raises(ElasticsearchException) do
        ElasticSearch.stub :new, @elasticsearch_adapter_mock do
          @teacher_set.create_or_update_teacherset_document_in_es
        end
      end
      assert_equal(ELASTIC_SEARCH_STANDARD_EXCEPTION[:code], resp.code)
      assert_equal(ELASTIC_SEARCH_STANDARD_EXCEPTION[:msg], resp.message)
      @elasticsearch_adapter_mock.verify
    end
  end


  # Delete teacher-set document in ES
  describe "Delete teacherset record from elastic search" do

    it 'Delete teacher_set document from Elastic search' do
      response = {"found" => true, "result" => 'deleted'}
      @elasticsearch_adapter_mock.expect(:delete_document_by_id, response, [@teacher_set.id])
      resp = nil
      ElasticSearch.stub :new, @elasticsearch_adapter_mock do
        @teacher_set.delete_teacherset_record_from_es
      end
      @elasticsearch_adapter_mock.verify
    end

    it 'raises ElasticsearchException when ElasticSearch raises NotFound' do
      resp = nil
      detail_msg = "Teacher set data not found."
      @elasticsearch_adapter_mock.expect(:delete_document_by_id, nil) do
        raise Elasticsearch::Transport::Transport::Errors::NotFound, detail_msg
      end

      resp = assert_raises(ElasticsearchException) do
        ElasticSearch.stub :new, @elasticsearch_adapter_mock do
          @teacher_set.delete_teacherset_record_from_es
        end
      end
      assert_equal(TEACHER_SET_NOT_FOUND_IN_ES[:code], resp.code)
      assert_equal(TEACHER_SET_NOT_FOUND_IN_ES[:msg], resp.message)
      @elasticsearch_adapter_mock.verify
    end

    it 'raises ElasticsearchException when ElasticSearch raises StandardError' do
      resp = nil
      detail_msg = 'exception occured'
      @elasticsearch_adapter_mock.expect(:delete_document_by_id, nil) do
        raise StandardError, detail_msg
      end
      resp = assert_raises(ElasticsearchException) do
        ElasticSearch.stub :new, @elasticsearch_adapter_mock do
          @teacher_set.delete_teacherset_record_from_es
        end
      end
      assert_equal(ELASTIC_SEARCH_STANDARD_EXCEPTION[:code], resp.code)
      assert_equal(ELASTIC_SEARCH_STANDARD_EXCEPTION[:msg], resp.message)
      @elasticsearch_adapter_mock.verify
    end
  end


  # test teacher set object method.
  describe "test teacher set object" do
    it 'test teacher set object' do
      resp = @teacher_set.teacher_set_info
      assert_equal(@teacher_set.title, resp[:title])
      assert_equal(@teacher_set.bnumber, resp[:bnumber])
      assert_equal(@teacher_set.subjects.count, resp[:subjects].count)
    end
  end


  describe 'update set_type value in teacher_set table' do
    it 'test update_set_type value method' do
      resp = nil
      set_type_val = @teacher_set3.set_type
      resp = @teacher_set3.update_set_type(set_type_val)
      assert_equal(set_type_val, resp)
    end
  end


  describe 'get set-type value' do

    it 'get set_type value from bib_response' do
      bib_id = 7899158
      expected_resp = OpenStruct.new(data: SIERRA_USER["data"], code: 200)
      @mintest_mock1.expect(:call, expected_resp, [bib_id])
      resp = nil
      @teacher_set3.stub :send_request_to_bibs_microservice, @mintest_mock1 do
        resp = @teacher_set3.get_set_type_value_from_bib_response(bib_id)
      end
      assert_equal(TeacherSet::TOPIC_SET, resp)
      @mintest_mock1.verify
    end
  end


  describe 'recalculate teacher-set availability column' do
    it 'test recalculate_availability method' do
      resp = @teacher_set3.recalculate_availability
      assert_equal(true, resp)
    end
  end


  describe 'Get teacher_set by bib number' do
    it 'test get_teacher_set_by_bnumber method' do
      bib_id = 123
      resp = TeacherSet.get_teacher_set_by_bnumber(bib_id)
      assert_equal("b#{bib_id}", resp.bnumber)
    end
  end

  describe 'create or get teacher_set' do
    it 'test initialize_teacher_set method' do
      bib_id = 123
      resp = TeacherSet.initialize_teacher_set(bib_id)
      assert_equal("b#{bib_id}", resp.bnumber)
    end
  end


  describe 'update teacher_set attributes form bib response' do
    it 'test update_teacher_set_attributes_from_bib_request method' do
      ts_items_info = {bibs_resp: SIERRA_USER, total_count: 1, available_count: 1, availability_string: 'available'}
      req_body = SIERRA_USER['data'][0]
      @teacher_set.instance_variable_set(:@req_body, req_body)
      resp = @teacher_set.update_teacher_set_attributes_from_bib_request(ts_items_info)
      assert_equal(@teacher_set.bnumber, resp.bnumber)
    end
  end

  private

  def bib_id_not_found_response
    {"statusCode"=>404, "type"=>"exception", "message"=>"No records found", "error"=>[], "debugInfo"=>[]}
  end

  def bib_items_response
    { 'data' => [ {
          'nyplSource' => 'sierra-nypl', 
          'bibIds' => [
            '21480355'
          ],
          'status' => {
            'code' => 'W', 
            'display' => 'AVAILABLE', 
            'duedate' => '2011-04-26T16:16:00-04:00'
          },
        },
        {
          'nyplSource' => 'sierra-nypl', 
          'bibIds' => [
            '21480355'
          ],
          'status' => {
            'code' => '-', 
            'display' => 'AVAILABLE', 
            'duedate' => ""
          },
        }
         ],
      'count' => 2,
      'totalCount' => 2,
      'statusCode' => 200,
      'debugInfo' => []
    }
  end

end
