# frozen_string_literal: true

require 'test_helper'

class TeacherSetsEsHelperTest < Minitest::Test
  extend Minitest::Spec::DSL
  include TeacherSetsEsHelper

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
      resp = teacher_sets_from_elastic_search_doc(es_json)
      assert_equal(es_json[:hits].first["_id"], resp.first.id.to_s)
    end
  end
end
