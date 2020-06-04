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

  # Update teacher-set document in ES
  describe '#test create or update teacherset' do
    it 'update teacherset document in es' do
      es_doc = {"_index" => "teacherset", "_type" => "teacherset", 
                "_id" => "353", "_version" => 11, "result" => "noop", 
                "_shards" => {"total" => 0, "successful" => 0, "failed" => 0}}
      @mintest_mock2.expect(:update_document_by_id, es_doc, [@expected_resp[:id], @expected_resp])
      resp = nil
      ElasticSearch.stub :new, @mintest_mock2 do
        resp = create_or_update_teacherset_document_in_es(@teacher_set_obj)
      end
      assert_equal(true, resp)
    end
  end

  # Delete teacher-set document in ES
  describe "delete teacherset record from_es" do
    it 'test delete_teacherset_record_from_es' do
      expected_resp = {"_index" => "teacherset", "_type" => "teacherset", "_id" => "354", "_version" => 2, "result" => "deleted", 
        "_shards" => {"total" => 2, "successful" => 1, "failed" => 0}, "_seq_no" => 294, "_primary_term" => 2}
      @mintest_mock1.expect(:delete_document_by_id, expected_resp, [354])
      resp = nil
      ElasticSearch.stub :new, @mintest_mock1 do
        resp = delete_teacherset_record_from_es(354)
      end
      assert_equal(true, resp)
    end
  end

  # Create teacher set object from elastic search json
  describe "test create ts_object from es_json" do
    it "create ts_object from es json" do
      es_json = {:totalMatches => 1330,
                 :hits => 
                  [{"_index" => "teacherset", "_type" => "teacherset", "_id" => "352", "_score" => 1.0,
                    "_source" =>  {"title" => "Step Up to the Plate, Maria Singh by deepika.",
                      "description" =>  "desc",
                      "contents" => "Step Up to the Plate, Maria Singh / Uma Krishnaswami.",
                      "id" => 352,"details_url" => "http://catalog.nypl.org/record=b21378444~S1",
                      "grade_end" => 5,"grade_begin" => 3,"availability" => "available","total_copies" => 3,
                      "call_number" => "Teacher Set ELA B BC Krishnaswami 1","language" => nil,"physical_description" => "10 v.",
                      "primary_language" => "English","created_at" => "2020-05-12T19:32:15+0000","updated_at" => "2020-05-13T21:01:25+0000",
                      "available_copies" => 3,"bnumber" => "b21378444","set_type" => nil,
                      "area_of_study" => "English Language Arts", 
                      "subjects" => [{"id" => 65025, "title" => "East Indian Americans", "created_at" => "2020-05-11T16:39:52+0000", 
                                      "updated_at" => "2020-05-11T16:39:52+0000"}]},"sort" => [1.0, "available", 1589311935000, "352"]}]}
      resp = create_ts_object_from_es_json(es_json)
      assert_equal(es_json[:hits].first["_id"], resp.first.id.to_s)
    end
  end
end
