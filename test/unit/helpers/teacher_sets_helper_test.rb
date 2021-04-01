# frozen_string_literal: true

require 'test_helper'

class TeacherSetsHelperTest < MiniTest::Test
  extend Minitest::Spec::DSL
  include LogWrapper
  include TeacherSetsHelper

  def setup
    @mintest_mock1 = MiniTest::Mock.new
    @mintest_mock2 = MiniTest::Mock.new
    @mintest_mock3 = MiniTest::Mock.new
    created_at = Time.zone.parse("2014-10-19 1:00:00")
    updated_at = Time.zone.parse("2014-10-19 1:00:00")
    @teacher_set_obj = TeacherSet.new(title: "title", description: "description", contents: "contents", 
      id: "123", details_url: "details_url", grade_end: 1, 
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

  # test teacher set object method.
  describe "test teacher set object" do
    it 'test teacher set object' do
      resp = teacher_set_info(@teacher_set_obj)
      assert_equal(@expected_resp, resp)
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
