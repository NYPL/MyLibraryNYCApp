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
    @model = TeacherSet.new
    @mintest_mock1 = MiniTest::Mock.new
    @mintest_mock2 = MiniTest::Mock.new
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

      teacher_set.update_attributes(title: 'Title2')
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
          @model.stub :update_attributes, true, [total_copies: total_count, available_copies: available_count, availability: 'available'] do
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
  describe "update set_type value in teacher set table" do
    it "test set_type value with Topic set" do
      set_type_val = " Topic set "
      teacher_set = crank!(:teacher_set)
      resp = teacher_set.update_set_type(set_type_val)
      assert_equal(true, resp)
    end

    it "test set_type value with Topic set" do
      set_type_val = " Book Club Set "
      teacher_set = crank!(:teacher_set)
      resp = teacher_set.update_set_type(set_type_val)
      assert_equal(true, resp)
    end

    it "test set_type value with nil" do
      set_type_val = nil
      teacher_set = crank!(:teacher_set)
      resp = teacher_set.update_set_type(set_type_val)
      assert_equal(true, resp)
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

  def test_teacher_set_query
    params = {"page"=>"1", "controller"=>"teacher_sets", "action"=>"index", "format"=>"json"}
    resp = TeacherSet.for_query(params)
    assert_equal(2, resp.count)
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
