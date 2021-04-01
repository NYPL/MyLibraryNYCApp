# frozen_string_literal: true

require 'test_helper'

class TeacherSetsHelperTest < ActiveSupport::TestCase
  extend Minitest::Spec::DSL
  include LogWrapper
  include TeacherSetsHelper

  before do
    @mintest_mock1 = MiniTest::Mock.new
    @mintest_mock2 = MiniTest::Mock.new
    @mintest_mock3 = MiniTest::Mock.new
    created_at = Time.zone.parse("2014-10-19 1:00:00")
    updated_at = Time.zone.parse("2014-10-19 1:00:00")
    @expected_resp = {:title => "MyString", :description => "MyText", :contents => nil,
     :id => 252051579, :details_url => nil, :grade_end => nil, :grade_begin => nil,
     :availability => nil, :total_copies => nil, :call_number => nil, :language => nil,
     :physical_description => nil, :primary_language => nil, :created_at => "2014-10-19T01:00:00+0000",
     :updated_at => "2014-10-19T01:00:00+0000", :available_copies => 2,
     :bnumber => "123", :set_type => nil, :area_of_study => nil,
     :subjects => [{:id => 570218967, :title => "Authors Russiantest", :created_at => "2021-04-01T14:52:07+0000", :updated_at => "2021-04-01T14:52:07+0000"},
    {:id => 173724997, :title => "Social", :created_at => "2021-04-01T14:52:07+0000", :updated_at => "2021-04-01T14:52:07+0000"}]}
  end

  # test teacher set object method.
  describe "test teacher set object" do
    it 'test teacher set object' do
      @teacher_set = teacher_sets(:teacher_set_one)
      resp = teacher_set_info(@teacher_set)
      assert_equal(@expected_resp[:title], resp[:title])
    end
  end


  describe 'Get var field data from request body' do
    it 'test var-field method' do
      self.instance_variable_set(:@req_body, SIERRA_USER["data"][0])
      resp = var_field_data('300', merge = true)
      assert_equal("physical desc", resp)

      resp = var_field_data('300')
      assert_equal("physical desc", resp)
    end
  end

  describe 'Get all_var_fields data from request body' do
    it 'test all_var_fields method' do
      self.instance_variable_set(:@req_body, SIERRA_USER["data"][0])
      resp = all_var_fields('300')
      assert_equal(["physical desc"], resp)
    end
  end

  describe 'test grade value method' do
    it 'test pre-k grades' do
      resp = grade_val('K')
      assert_equal(0, resp)

      resp = grade_val('PRE K')
      assert_equal(-1, resp)

      resp = grade_val(1)
      assert_equal(1, resp)
    end
  end

  describe 'Get fixed_field data from request body' do
    it 'test fixed_field method' do
      self.instance_variable_set(:@req_body, SIERRA_USER["data"][0])
      resp = fixed_field('44')
      assert_equal("English", resp)
    end
  end
end
