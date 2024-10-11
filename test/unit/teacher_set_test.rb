# frozen_string_literal: true

require 'test_helper'
require 'mocha/minitest'

class TeacherSetTest < ActiveSupport::TestCase

  extend Minitest::Spec::DSL
  include LogWrapper
  include MlnResponse
  include MlnException

  before do
    @school1 = schools(:school_one)
    @school2 = schools(:school_two)
    @school3 = schools(:school_three)

    @user = holds(:hold1).user
    @hold1 = holds(:hold1)
    @hold2 = holds(:hold2)
    @hold4 = holds(:hold4)
    @hold9 = holds(:hold9)
    @hold10 = holds(:hold10)
    @user2 = holds(:hold9).user
    @user3 = holds(:hold10).user

    @teacher_set = teacher_sets(:teacher_set_one)
    @teacher_set2 = teacher_sets(:teacher_set_two)
    @teacher_set3 = teacher_sets(:teacher_set_three)
    @teacher_set4 = teacher_sets(:teacher_set_four)
    @teacher_set6 = teacher_sets(:teacher_set_six)
    @teacher_set7 = teacher_sets(:teacher_set_seven)
    @teacher_set8 = teacher_sets(:teacher_set_eight)
    @model = TeacherSet.new
    #@model.save!
    @mintest_mock1 = Minitest::Mock.new
    @mintest_mock2 = Minitest::Mock.new
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

  # Calls Bibs service
  # Calculates the total number of items and available items in the Bib service response
  describe 'test update available and total count method' do
    before do
      @elastic_search_mock = mock('ElasticSearch')
      @elastic_search_mock.stubs(:update_document_by_id).returns(true)
      ElasticSearch.stubs(:new).returns(@elastic_search_mock)
    end

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
    it "test current-user teacher-set holds count with hold_id" do
      resp = @teacher_set2.holds_count_for_user(@user, @hold2.id)
      assert_equal(1, resp)
    end

    # Test-2
    it "test current-user holds count" do
      assert_equal(1, @teacher_set2.holds_count_for_user(@user))
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
      assert_equal([@hold2], @teacher_set2.holds_for_user(@user, @hold2.id))
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

  describe 'Test delete teacher_set record' do
    it 'Delete teacher_set record in db and elastic search' do
      es_resp = {"found" => true, "result" => 'deleted'}
      bib_id = '999999'
      # Create dedicated teacher-set record with bib_id '99999'.
      TeacherSet.new(bnumber: "b#{bib_id}").save
      resp = nil
      # Delete teacher_set record
      TeacherSet.stub_any_instance :delete_teacherset_record_from_es, es_resp do
        resp = TeacherSet.delete_teacher_set(bib_id)
      end
      assert_equal("b#{bib_id}", resp.bnumber)
    end

    it 'test bib record not found exception' do
      bib_id = '000'
      resp = assert_raises(BibRecordNotFoundException) do
        TeacherSet.delete_teacher_set(bib_id)
      end
      assert_equal(BIB_RECORD_NOT_FOUND[:code], resp.code)
      assert_equal(BIB_RECORD_NOT_FOUND[:msg], resp.message)
    end
  end

  describe 'create_or_update_teacherset ' do
    it 'test create or update teacherset' do
      resp = nil
      es_resp = {"_index"=>"teacherset", "_type"=>"teacherset", "_id"=>914202741, "_version"=>11, 
                 "result"=>"updated", "_shards"=>{"total"=>0, "successful"=>1, "failed"=>0}}

      SIERRA_USER["data"][0]['id'] = rand.to_s[3..8]
      bib_id = SIERRA_USER["data"][0]['id']

      SIERRA_USER["data"][0]['suppressed'] = false
      ts_items_info = {bibs_resp: SIERRA_USER, total_count: 1, available_count: 1, availability_string: 'available'}

      TeacherSet.stub_any_instance :get_items_info_from_bibs_service, ts_items_info do
        TeacherSet.stub_any_instance :create_or_update_teacherset_document_in_es, es_resp do
          resp = TeacherSet.create_or_update_teacher_set(SIERRA_USER["data"][0])
        end
      end
      assert_equal("b#{bib_id}", resp.bnumber)
    end

    it 'Bib request-body has suppressed value as true then delete teacher-set from database and elastic-search' do
      bib_id = rand.to_s[2..8] 
      # Create dedicated teacher-set record with bib_id
      TeacherSet.create(bnumber: "b#{bib_id}")

      SIERRA_USER["data"][0]['suppressed'] = true
      SIERRA_USER["data"][0]['id'] = bib_id

      es_response = {"found" => true, "result" => 'deleted'}
      resp = assert_raises(SuppressedBibRecordException) do
        TeacherSet.stub_any_instance :delete_teacherset_record_from_es, es_response do
          TeacherSet.create_or_update_teacher_set(SIERRA_USER["data"][0])
        end
      end

      assert_equal(BIB_RECORD_SUPPRESSED_REMOVED_FROM_MLN[:code], resp.code)
      assert_equal(BIB_RECORD_SUPPRESSED_REMOVED_FROM_MLN[:msg], resp.message)
    end

    it 'Bib request-body has suppressed value as true but teacher-set record not found in database' do
      bib_id = rand.to_s[2..8]
      # Created teacher-set record not saved in DB.
      TeacherSet.new(bnumber: "b#{bib_id}")

      SIERRA_USER["data"][0]['suppressed'] = true
      SIERRA_USER["data"][0]['id'] = bib_id

      resp = assert_raises(SuppressedBibRecordException) do
        TeacherSet.create_or_update_teacher_set(SIERRA_USER["data"][0])
      end
      assert_equal(BIB_RECORD_SUPPRESSED_NOT_ADDED_TO_MLN[:code], resp.code)
      assert_equal(BIB_RECORD_SUPPRESSED_NOT_ADDED_TO_MLN[:msg], resp.message)
    end
  end

  # Update teacher-set document in ES
  describe '#test create or update teacherset' do
    before do
      @es_doc = {"_index" => "teacherset", "_type" => "teacherset",
                "_id" => 8888, "_version" => 11, "result" => "updated",
                "_shards" => {"total" => 0, "successful" => 1, "failed" => 0}}
      @expected_resp = {:title=>"title",:description=>"desc",
                        :contents=>nil,:id=>8888,:details_url=>nil,:grade_end=>nil,
                        :grade_begin=>nil,:availability=>"unavailable",:total_copies=>nil,:call_number=>nil,
                        :language=>nil,:physical_description=>nil,:primary_language=>nil,
                        :created_at=>nil,:updated_at=>nil,:available_copies=>nil,:bnumber=>"bnumber",
                        :set_type=>nil,:area_of_study=>nil,:subjects=>[]}
    end

    it 'update teacher-set document in ElasticSearch' do
      resp = nil
      teacher_set = TeacherSet.new(title: 'title', description: 'desc', bnumber: "bnumber", id: "8888")
      elasticsearch_adapter_mock = Minitest::Mock.new
      elasticsearch_adapter_mock.expect(:update_document_by_id, @es_doc, [teacher_set.id, @expected_resp])
      ElasticSearch.stub :new, elasticsearch_adapter_mock do
        resp = teacher_set.create_or_update_teacherset_document_in_es
      end
      assert_equal(teacher_set.id.to_i, resp["_id"])
      elasticsearch_adapter_mock.verify
    end


    it 'raises ElasticsearchException when ElasticSearch raises StandardError' do
      detail_msg = 'exception occured'
      teacher_set = TeacherSet.new(title: 'title', description: 'desc', bnumber: "bnumber", id: "8888")
      elasticsearch_adapter_mock = Minitest::Mock.new
      elasticsearch_adapter_mock.expect(:update_document_by_id, nil) do
        raise StandardError, ELASTIC_SEARCH_STANDARD_EXCEPTION[:msg]
      end

      resp = assert_raises(ElasticsearchException) do
        ElasticSearch.stub :new, elasticsearch_adapter_mock do
          teacher_set.create_or_update_teacherset_document_in_es
        end
      end
      assert_equal(ELASTIC_SEARCH_STANDARD_EXCEPTION[:code], resp.code)
      assert_equal(ELASTIC_SEARCH_STANDARD_EXCEPTION[:msg], resp.message)
      elasticsearch_adapter_mock.verify
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
      set_type = "Book Club Set ."
      resp = @teacher_set3.update_set_type(set_type)
      assert_equal(@teacher_set3.set_type, resp)
    end
  end


  describe 'get set-type value' do

    it 'get set_type value from bib_response' do
      bib_id = 7899158
      expected_resp = Struct.new(:data, :code).new(SIERRA_USER["data"], 200)

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


  describe 'teacher_set#update_teacher_set_availability_in_db' do

    it 'update teacher-set availability while creation the hold ' do
      # Teacher-set available_copies and availability before creation of hold
      assert_equal('available', @teacher_set7.availability)
      assert_equal(2, @teacher_set7.available_copies)
      resp = @teacher_set7.update_teacher_set_availability_in_db('create', @hold9.quantity)
      # After creation of hold, available_copies is zero and availability changed to 'unavailable'
      assert_equal("unavailable", @teacher_set7.availability)
      assert_equal(0, @teacher_set7.available_copies)
      assert_equal(true, resp)
    end

    it 'update teacher-set availability while cancellation of hold ' do
      # Teacher-set available_copies and availability before cancellation of hold
      assert_equal('unavailable', @teacher_set8.availability)
      assert_equal(0, @teacher_set8.available_copies)
      resp = @teacher_set8.update_teacher_set_availability_in_db('cancelled', nil, @user3, @hold10.id)

      # After cancellation of hold available_copies count increased and availability status changed to 'available'
      assert_equal(2, @teacher_set8.available_copies)
      assert_equal('available', @teacher_set8.availability)
      assert_equal(true, resp)
    end

  end


  describe 'teacher_set#calculate_available_copies' do
    it 'calculate teacher-set available copies while cancelling the hold' do
      # available_copies before cancellation of hold
      available_copies_before_cancellation = @teacher_set2.available_copies
      available_copies_after_cancellation = @teacher_set2.calculate_available_copies('cancelled', nil, @user, @hold2.id)
      assert_equal(2, available_copies_before_cancellation)
      # After cancellation of hold available_copies count increased.
      assert_equal(3, available_copies_after_cancellation)
    end

    it 'calculate teacher-set available copies while creating the hold' do
      # available_copies before creating hold
      available_copies_before_creation = @teacher_set2.available_copies
      available_copies_after_creation = @teacher_set4.calculate_available_copies('create', @hold4.quantity)
      assert_equal(2, available_copies_before_creation)
      # After creation of hold available_copies count decreased.
      assert_equal(0, available_copies_after_creation)
    end
  end

  describe 'teacher_set#update_teacher_set_availability_in_elastic_search' do
    it 'should call ElasticSearch#update_document_by_id' do
      resp = nil
      elasticsearch_adapter_mock = Minitest::Mock.new
      es_doc = {"_index" => "teacherset", "_type" => "teacherset",
                "_id" => @teacher_set2.id, "_version" => 11, "result" => "updated",
                "_shards" => {"total" => 0, "successful" => 1, "failed" => 0}}
      body = {
         :availability => @teacher_set2.availability,
         :available_copies => @teacher_set2.available_copies
        }

      elasticsearch_adapter_mock.expect(:update_document_by_id, es_doc, [@teacher_set2.id, body])
      ElasticSearch.stub :new, elasticsearch_adapter_mock do
        resp = @teacher_set2.update_teacher_set_availability_in_elastic_search
      end
      assert_equal(resp['result'], "updated")
      elasticsearch_adapter_mock.verify
    end
  end


  describe 'teacher_set#teacher_set_availability' do
    it 'get teacher_set availability based on the available copies' do
      ts_availability = @teacher_set2.availability
      assert_equal('available', ts_availability)
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
