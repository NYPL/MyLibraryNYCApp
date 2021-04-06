# frozen_string_literal: true

require 'test_helper'

class TeacherSetTest < ActiveSupport::TestCase

  extend Minitest::Spec::DSL
  include LogWrapper

  before do
    @user = holds(:hold1).user
    @hold1 = holds(:hold1)
    @hold2 = holds(:hold2)
    @teacher_set = teacher_sets(:teacher_set_one)
    @teacher_set2 = teacher_sets(:teacher_set_two)
    @teacher_set3 = teacher_sets(:teacher_set_three)
    @teacher_set4 = teacher_sets(:teacher_set_four)
    @model = TeacherSet.new
    @mintest_mock1 = MiniTest::Mock.new
    @mintest_mock2 = MiniTest::Mock.new
    @mintest_mock3 = MiniTest::Mock.new
    @mintest_mock4 = MiniTest::Mock.new
    @mintest_mock5 = MiniTest::Mock.new
    @mintest_mock6 = MiniTest::Mock.new
    @mintest_mock7 = MiniTest::Mock.new
    @mintest_mock8 = MiniTest::Mock.new
    @mintest_mock9 = MiniTest::Mock.new
    @mintest_mock10 = MiniTest::Mock.new
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

  describe 'create_or_update_teacherset ' do
    it 'test create or update teacherset' do
      ts_items_info = {bibs_resp: SIERRA_USER, total_count: 1, available_count: 1, availability_string: 'available'}
      TeacherSet.instance_variable_set(:@req_body, SIERRA_USER["data"][0])
      bnumber = {bnumber: "b7899158"}
      teacher_set = TeacherSet.new(bnumber: "b7899158")
      subjects_arr = ["Elections."]

      resp = nil
      @mintest_mock2.expect(:call, ts_items_info, [7899158])
      @mintest_mock3.expect(:call, teacher_set, [ts_items_info])
      @mintest_mock4.expect(:call, teacher_set)
      @mintest_mock5.expect(:call, subjects_arr, ['650'])
      @mintest_mock6.expect(:call, teacher_set, [subjects_arr])
      @mintest_mock7.expect(:call, "Learning set", ['500', true])
      @mintest_mock8.expect(:call, teacher_set, ["Learning set"])
      @mintest_mock9.expect(:call, teacher_set, [SIERRA_USER["data"][0]])
      @mintest_mock10.expect(:call, teacher_set)

      TeacherSet.stub :initialize_teacher_set, teacher_set, ['7899158'] do
        teacher_set.stub :get_items_info_from_bibs_service, @mintest_mock2 do
          teacher_set.stub :update_teacher_set_attributes_from_bib_request, @mintest_mock3 do
            teacher_set.stub :clean_primary_subject, @mintest_mock4 do
              teacher_set.stub :all_var_fields, @mintest_mock5 do
                teacher_set.stub :update_subjects_via_api, @mintest_mock6 do
                  teacher_set.stub :var_field_data, @mintest_mock7 do
                    teacher_set.stub :update_notes, @mintest_mock8 do
                      teacher_set.stub :update_included_book_list, @mintest_mock9 do
                        teacher_set.stub :create_or_update_teacherset_document_in_es, @mintest_mock10 do
                          resp = TeacherSet.create_or_update_teacher_set_data(SIERRA_USER["data"][0])
                        end
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end
      assert_equal(teacher_set.bnumber, resp.bnumber)
      @mintest_mock1.verify
      @mintest_mock2.verify
      @mintest_mock3.verify
      @mintest_mock4.verify
      @mintest_mock5.verify
      @mintest_mock6.verify
      @mintest_mock7.verify
      @mintest_mock8.verify
      @mintest_mock9.verify
      @mintest_mock10.verify
    end
  end

  def test_teacher_set_query
    params = {"page"=>"1", "controller"=>"teacher_sets", "action"=>"index", "format"=>"json"}
    resp = TeacherSet.for_query(params)
    assert_equal(4, resp.count)
  end


  # Update teacher-set document in ES
  describe '#test create or update teacherset' do
    before do
      @es_doc = {"_index" => "teacherset", "_type" => "teacherset", 
                "_id" => "353", "_version" => 11, "result" => "noop", 
                "_shards" => {"total" => 0, "successful" => 0, "failed" => 0}}
      
      created_at = Time.zone.parse("2014-10-19 1:00:00")
      updated_at = Time.zone.parse("2014-10-19 1:00:00")
      @ts_obj = TeacherSet.new(title: "title", description: "description", contents: "contents", 
      id: 123, details_url: "details_url", grade_end: 1, 
      grade_begin: 1, availability: "available", total_copies: 1,
      call_number: 12345, language: "English", physical_description: "physical_description",
      primary_language: "English", created_at: created_at, updated_at: updated_at,
      available_copies: 1, bnumber: "B456", set_type: "set_type",
      area_of_study: "area_of_study", subjects: [])

      @expected_resp = {:title => "title",:description => "description",:contents => "contents",
       :id => 123,:details_url => "details_url",:grade_end => 1,:grade_begin => 1,:availability => "available",
       :total_copies => 1, :call_number => "12345",:language => "English",
       :physical_description => "physical_description",:primary_language => "English",
       :created_at => "2014-10-19T01:00:00+0000",:updated_at => "2014-10-19T01:00:00+0000",:available_copies => 1,
       :bnumber => "B456",:set_type => "set_type",:area_of_study => "area_of_study",:subjects => []}
    end

    it 'update teacher-set document in es' do
      resp = nil
      @mintest_mock1.expect(:call, @expected_resp, [@ts_obj])
      @mintest_mock2.expect(:update_document_by_id, @es_doc, [@expected_resp[:id], @expected_resp])
      @teacher_set.stub :teacher_set_info, @mintest_mock1 do
        ElasticSearch.stub :new, @mintest_mock2 do
          resp = @ts_obj.create_or_update_teacherset_document_in_es
        end
      end
      assert_equal(188, resp)
    end
  end

  # Delete teacher-set document in ES
  describe "delete teacherset record from_es" do
    it 'test delete_teacherset_record_from_es' do
      expected_resp = {"_index" => "teacherset", "_type" => "teacherset", "_id" => @teacher_set.id, "_version" => 2, "result" => "deleted", 
        "_shards" => {"total" => 2, "successful" => 1, "failed" => 0}, "_seq_no" => 294, "_primary_term" => 2}
      @mintest_mock2.expect(:delete_document_by_id, expected_resp, [@teacher_set.id])
      resp = nil
      ElasticSearch.stub :new, @mintest_mock2 do
        resp = @teacher_set.delete_teacherset_record_from_es
      end
      assert_equal(184, resp)
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
