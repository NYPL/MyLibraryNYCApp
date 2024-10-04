# frozen_string_literal: true

require 'test_helper'
class ElasticSearchTest < Minitest::Test

  extend Minitest::Spec::DSL
  include LogWrapper

  def setup
    @es_model = ElasticSearch.new
    @mintest_mock1 = MiniTest::Mock.new
    @mintest_mock2 = MiniTest::Mock.new
    # models the format of the ES query terms, the structure we'll be sending our search requests in
    @agg_hash = {"language" => {:terms => {:field => "primary_language", :size => 100, :order => {:_key => "asc"}}},
        "set type" => {:terms => {:field => "set_type", :size => 10, :order => {:_key => "asc"}}},
        "availability" => {:terms => {:field => "availability.raw", :size => 10, :order => {:_key => "asc"}}},
        "area of study" => {:terms => {:field => "area_of_study", :size => 100, :order => {:_key => "asc"}}},
        "subjects" =>  {:nested => {:path => "subjects"}, :aggregations => {:subjects => {:composite => {:size => 3000, 
          :sources => [{:id => {:terms => {:field => "subjects.id"}}}, 
                       {:title => {:terms => {:field => "subjects.title.keyword"}}}]}}}}}
  end


  # Teacher set property fields are correctly parsed out from request data
  describe "test_teacher_sets_input_params" do
    it 'teacher sets input params' do
      params = {"keyword" => "test", "grade_begin" => 1, "grade_end" => 2, "language" => "english", 
        "set type" => "type", "availability" => "availability", "area of study" => "area of study", "subjects" => ["123"]}
      resp = @es_model.teacher_sets_input_params(params)
      assert_equal(params.values, resp)
    end
  end


  # Test search queries based on input filter params.
  # filters = language, set_type, availability, area_of_study, subjects
  describe "test teacher sets query based on filters" do

    # If search keyword is present in filters, finding the search keyword in these fields [title, description, contents]
    it 'teacher sets query by keyword' do
      resp = nil
      params = { "keyword" => "test" }
      expected_resp = [{:query => 
        {:bool => 
           {:must => 
             [{:bool => 
                {:should => 
                  [{:multi_match => {:query => "test", :type => "phrase_prefix", :boost => 3, :fields => ["title^10", "description^2", "contents"]}},
                   {:multi_match => {:query => "test", :fuzziness => 1, :fields => ["title^10", "description^2", "contents"]}},
                   {:nested => 
                     {:path => "subjects",
                      :query => 
                       [{:multi_match => {:query => "test", :type => "phrase_prefix", :boost => 3, :fields => ["subjects.title^3"]}}, 
                        {:multi_match => {:query => "test", :fuzziness => 1, :fields => ["subjects.title^3"]}}]}},
                   {:term => {:'title.keyword' => {:value => "test"}}}]}}]}}},
                    {"language" => {:terms => {:field => "primary_language", :size => 100, :order => {:_key => "asc"}}},
                     "set type" => {:terms => {:field => "set_type", :size => 10, :order => {:_key => "asc"}}},
                     "availability" => {:terms => {:field => "availability.raw", :size => 10, :order => {:_key => "asc"}}},
                     "area of study" => {:terms => {:field => "area_of_study", :size => 100, :order => {:_key => "asc"}}},
                     "subjects" => 
                      { :nested => {:path => "subjects"}, :aggregations => {:subjects => {:composite => {:size => 3000,
                        :sources => [{:id => {:terms => {:field => "subjects.id"}}}, 
                                     {:title => {:terms => {:field => "subjects.title.keyword"}}}]}}}}}]


      @mintest_mock1.expect(:call, ["test"], [params])
      @mintest_mock2.expect(:call, @agg_hash, [{}])

      @es_model.stub :teacher_sets_input_params, @mintest_mock1 do
        @es_model.stub :group_by_facets_query, @mintest_mock2 do
          resp = @es_model.teacher_sets_query_based_on_filters(params)
        end
      end
      assert_equal(expected_resp, resp)
      @mintest_mock1.verify
      @mintest_mock2.verify
    end

    # If availability present in filters get ES query based on availability.
    # Eg: availability: "available/unavailable"
    it 'teacher sets query by availability' do
      resp = nil
      params = { "availability" => "available" }
      @mintest_mock1.expect(:call, [nil, nil, nil, nil, nil, ["available"]], [params])
      @mintest_mock2.expect(:call, @agg_hash, [{}])
      expected_resp = [{:query => {:bool => {:must => [{:match => {:availability => "available"}}]}}}] << @agg_hash

      @es_model.stub :teacher_sets_input_params, @mintest_mock1 do
        @es_model.stub :group_by_facets_query, @mintest_mock2 do
          resp = @es_model.teacher_sets_query_based_on_filters(params)
        end
      end
      assert_equal(expected_resp, resp)
      @mintest_mock1.verify
      @mintest_mock2.verify
    end

    # If grade_begin, grade_end ranges present in filters get ES query based on ranges.
    # grade_begin value should be less than grade_end value
    # grade_end value should be greater than grade_begin value
    it 'teacher sets query by grade_begin and grade_end' do
      params = { "grade_begin" => 1, "grade_end" => 2 }
      @mintest_mock1.expect(:call, [nil, 1, 2], [params])
      @mintest_mock2.expect(:call, @agg_hash, [{}])
      expected_resp = [{:query => {:bool => {:must => [{:range => {:grade_begin => {:lte => 2}}},
                                                       {:range => {:grade_end => {:gte => 1}}}]}}}] << @agg_hash
      resp = nil
      @es_model.stub :teacher_sets_input_params, @mintest_mock1 do
        @es_model.stub :group_by_facets_query, @mintest_mock2 do
          resp = @es_model.teacher_sets_query_based_on_filters(params)
        end
      end
      assert_equal(expected_resp, resp)
      @mintest_mock1.verify
      @mintest_mock2.verify
    end

    # If area_of_study present in filters get ES query based on area_of_study.
    # Eg: area_of_study: "Social Studies"
    it 'teacher sets query by area_of_study' do
      params = { "area of study" => ['area_of_study'] }
      @mintest_mock1.expect(:call, [nil, nil, nil, nil, nil, nil, ['area_of_study']], [params])
      @mintest_mock2.expect(:call, @agg_hash, [{}])
      expected_resp = [{:query => {:bool => {:must => [{:match => {:area_of_study => "area_of_study"}}] }}}] << @agg_hash
      resp = nil
      @es_model.stub :teacher_sets_input_params, @mintest_mock1 do
        @es_model.stub :group_by_facets_query, @mintest_mock2 do
          resp = @es_model.teacher_sets_query_based_on_filters(params)
        end
      end
      assert_equal(expected_resp, resp)
      @mintest_mock1.verify
      @mintest_mock2.verify
    end

    # If set_type present in filters get ES query based on set_type.
    it 'teacher sets query by set_type' do
      params = { "set type" => ['set_type'] }
      @mintest_mock1.expect(:call, [nil, nil, nil, nil, ['set_type']], [params])
      @mintest_mock2.expect(:call, @agg_hash, [{}])
      expected_resp = [{:query => {:bool => {:must => [{:match => {:set_type => "set_type"}}] }}}] << @agg_hash
      resp = nil
      @es_model.stub :teacher_sets_input_params, @mintest_mock1 do
        @es_model.stub :group_by_facets_query, @mintest_mock2 do
          resp = @es_model.teacher_sets_query_based_on_filters(params)
        end
      end
      assert_equal(expected_resp, resp)
      @mintest_mock1.verify
      @mintest_mock2.verify
    end

    # If subjects present in filters get ES query based on subjects.
    # teacherset have has_many  relationship with subject.
    # subjects mapping are stored in nested format in elastic search. 
    it 'teacher sets query by subjects' do
      params = { "subjects" => ['123'] }
      @mintest_mock1.expect(:call, [nil, nil, nil, nil, nil, nil, nil, ['123']], [params])
      @mintest_mock2.expect(:call, @agg_hash, [{}])
      expected_resp = [{:query => {:bool => {:must => [{:nested => {:path => "subjects", 
                        :query => {:bool => {:must => [{:terms => {"subjects.id" => ["123"]}}]}}}}]}}}] << @agg_hash
      resp = nil
      @es_model.stub :teacher_sets_input_params, @mintest_mock1 do
        @es_model.stub :group_by_facets_query, @mintest_mock2 do
          resp = @es_model.teacher_sets_query_based_on_filters(params)
        end
      end
      assert_equal(expected_resp, resp)
      @mintest_mock1.verify
      @mintest_mock2.verify
    end

    it 'teacher sets query by language' do
      params = { "language" => ['language'] }
      @mintest_mock1.expect(:call, [nil, nil, nil, ['language']], [params])
      @mintest_mock2.expect(:call, @agg_hash, [{}])
      expected_resp = [{:query => {:bool => {:must => [{:multi_match => {:query => "language", :fields => %w[language primary_language]}}]}}}]
      expected_resp << @agg_hash

      resp = nil
      @es_model.stub :teacher_sets_input_params, @mintest_mock1 do
        @es_model.stub :group_by_facets_query, @mintest_mock2 do
          resp = @es_model.teacher_sets_query_based_on_filters(params)
        end
      end
      assert_equal(expected_resp, resp)
      @mintest_mock1.verify
      @mintest_mock2.verify
    end
  end

  
  # User query fields are correctly formatted into an aggregate query structure
  describe 'test group_by facets_query' do
    it 'test group_by facets query' do
      aggregation_hash = {}
      resp = @es_model.group_by_facets_query(aggregation_hash)
      assert_equal(@agg_hash, resp)
    end
  end

  # Make sure the facets_for_teacher_sets method can parse ES results.
  describe 'test facets for teacher_sets' do
    it 'test facets for teacher_sets' do
      facets = []
      resp = nil
      expected_facets = [
        {:label => "language", :items => [{:value => "English", :label => "English", :count => 1}]},
        {:label => "availability", :items => [{:value => "available", :label => "Available", :count => 1}]},
        {:label => "set type", :items => [{:value => "multi", :label => "Topic Sets", :count => 1}]},
        {:label => "area of study", :items => [{:value => "Arabic Language Arts.", :label => "Arabic Language Arts.", :count => 1}]}
      ]

      @mintest_mock1.expect(:call, expected_facets, [es_document_resp, facets])
      subjects_facets = {:label => "subjects", :items => [{:value => "123", :label => "subject", :count => 5}]}
      @mintest_mock2.expect(:call, subjects_facets, [es_document_resp, expected_facets])

      @es_model.stub :get_language_availability_set_type_area_of_study_facets, @mintest_mock1 do
        @es_model.stub :get_subject_facets, @mintest_mock2 do
          resp = @es_model.facets_for_teacher_sets(es_document_resp)
        end
      end
      assert_equal(teacherset_facets, resp)                    
    end
  end

  # Test subject facets
  # facets eg: [ {:label=>"language", :items=> [{:value=>"Chinese", :label=>"Chinese", :count=>34}]},
  # {:label=>"availability", :items=>[{:value=>"available", :label=>"Available", :count=>1223}, {:value=>"unavailable", 
  # :label=>"Checked Out", :count=>32}]},
  # {:label=>"set type", :items=>[{:value=>"multi", :label=>"Topic Sets", :count=>910}, {:value=>"single", :label=>"Book Club Set", :count=>276}]},
  # {:label=>"area of study", :items=> [{:value=>"Arabic Language Arts.", :label=>"Arabic Language Arts.", :count=>1}]}]
  describe 'test subject facets' do
    it 'test subject facets' do
      facets = [
        {:label => "language", :items => [{:value => "English", :label => "English", :count => 1}]},
        {:label => "availability", :items => [{:value => "available", :label => "Available", :count => 1}]},
        {:label => "set type", :items => [{:value => "multi", :label => "Topic Sets", :count => 1}]},
        {:label => "area of study", :items => [{:value => "Arabic Language Arts.", :label => "Arabic Language Arts.", :count => 1}]}
      ]
      resp = @es_model.get_subject_facets(es_document_resp, facets)
      assert_equal(teacherset_facets[1], resp)
    end
  end

  # Test group by facets from elasticsearch (language, availability, set_type, area_of_study) 
  describe 'test language availability set_type area_of_study facts' do
    it 'get language_availability_set_type_area_of_study_facts' do
      expected_resp = [{:label => "language", :items => [{:value => "English", :label => "English", :count => 1}]},
                       {:label => "availability", :items => [{:value => "available", :label => "Available", :count => 1}]},
                       {:label => "set type", :items => [{:value => "multi", :label => "multi", :count => 1}]},
                       {:label => "area of study", :items => [{:value => "Arabic Language Arts.", :label => "Arabic Language Arts.", :count => 1}]}]
      resp = @es_model.get_language_availability_set_type_area_of_study_facets(es_document_resp, [])
      assert_equal(expected_resp, resp)
    end
  end

  private

  def teacherset_facets
    [
      {:label => "area of study", :items => [{:value => "Arabic Language Arts.", :label => "Arabic Language Arts.", :count => 1}]},
      {:label => "subjects", :items => [{:value => "123", :label => "subject", :count => 5}]},
      {:label => "language", :items => [{:value => "English", :label => "English", :count => 1}]},
      {:label => "set type", :items => [{:value => "multi", :label => "Topic Sets", :count => 1}]},
      {:label => "availability", :items => [{:value => "available", :label => "Available", :count => 1}]}
    ]
  end


  def es_document_resp
    {:totalMatches => 1,
     :hits => 
      [{"_index" => "teacherset",
        "_type" => "teacherset",
        "_id" => "21187700052907",
        "_score" => 5.2185526,
        "_source" => 
         {"title" => "Arabic",
          "contents" => "Eating the Rainbowat's in My Garden?",
          "id" => 21187700052907,
          "details_url" => "http://catalog.nypl.org/record=b21187700~S1",
          "grade_end" => 0,
          "grade_begin" => 0,
          "availability" => "available",
          "total_copies" => 3,
          "call_number" => "Teacher Set ALA A Bilingual 1",
          "language" => "English",
          "physical_description" => "12 v.",
          "primary_language" => "English",
          "created_at" => "2017-05-12T14:17:24+0000",
          "updated_at" => "2019-07-25T20:00:35+0000",
          "available_copies" => 2,
          "bnumber" => "b21187700",
          "set_type" => "multi",
          "area_of_study" => "Arabic Language Arts.",
          "subjects" => []},
        "sort" => [5.2185526, "available", 1494598644000, "21187700052907"]}],
     :aggregations => 
      {"set type" => {"doc_count_error_upper_bound" => 0, "sum_other_doc_count" => 0, "buckets" => [{"key" => "multi", "doc_count" => 1}]},
       "area of study" => {"doc_count_error_upper_bound" => 0, "sum_other_doc_count" => 0, "buckets" => [{"key" => "Arabic Language Arts.", 
        "doc_count" => 1}]},
       "subjects" => {"doc_count" => 0, "subjects" => {"buckets" => [{"key" => {"id" => "123", "title" => "subject"}, "doc_count" => 5}]}},
       "language" => {"doc_count_error_upper_bound" => 0, "sum_other_doc_count" => 0, "buckets" => [{"key" => "English", "doc_count" => 1}]},
       "availability" => {"doc_count_error_upper_bound" => 0, "sum_other_doc_count" => 0, "buckets" => [{"key" => "available", "doc_count" => 1}]}}}
  end
end
