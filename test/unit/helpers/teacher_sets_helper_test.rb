# frozen_string_literal: true

require 'test_helper'

class TeacherSetsHelperTest < ActiveSupport::TestCase
  extend Minitest::Spec::DSL
  include LogWrapper
  include TeacherSetsHelper

  before do
    @teacher_set = TeacherSet.new
    @mintest_mock1 = Minitest::Mock.new
    @mintest_mock2 = Minitest::Mock.new
  end

  describe 'Get var field data from request body' do
    it 'test var-field method' do
      self.instance_variable_set(:@req_body, SIERRA_USER["data"][0])
      assert_equal("physical desc", var_field_data('300', true))
    end

    it 'test var-field method with content' do
      self.instance_variable_set(:@req_body, SIERRA_USER["data"][0])
      assert_equal("physical desc", var_field_data('300', false))
    end

    it 'test var-field method with req_body nil' do
      self.instance_variable_set(:@req_body, nil)
      assert_equal(nil, var_field_data('300'))
    end
  end

  describe 'Get all_var_fields data from request body' do
    it 'test all_var_fields method' do
      self.instance_variable_set(:@req_body, SIERRA_USER["data"][0])
      assert_equal(["physical desc"], all_var_fields('300'))
    end

    it 'test all_var_fields method with req_body nil' do
      self.instance_variable_set(:@req_body, nil)
      assert_nil(all_var_fields('300'))
    end
  end

  describe 'test grade value method' do
    it 'test pre-k and K grades' do
      assert_equal(0, grade_val('K'))

      assert_equal(-1, grade_val('PRE K'))

      assert_equal(1, grade_val(1))
    end
  end

  describe 'Get fixed_field data from request body' do
    it 'test fixed_field method with req_body' do
      self.instance_variable_set(:@req_body, SIERRA_USER["data"][0])
      assert_equal("English", fixed_field('44'))
    end

    it 'test fixed_field method with req_body nil' do
      self.instance_variable_set(:@req_body, nil)
      assert_nil(fixed_field('44'))
    end
  end

  describe 'test grades' do
    it 'test grades from prek to 12' do
      grades = ["3-8"]
      assert_equal(grades, get_grades(grades))
    end

    it 'test unknown grades' do
      grades = ["14"]
      assert_equal([-1], get_grades(grades))

      grades = ["1-14"]
      assert_equal(["1"], get_grades(grades))

      grades = ["14-2"]
      assert_equal(["2"], get_grades(grades))
    end
  end

  describe 'return teacher-set grades' do
    # Test1
    it 'test teacher_set grades' do
      self.instance_variable_set(:@req_body, SIERRA_USER["data"][0])
      return_grades = %w[3 8]
      assert_equal(return_grades, grade_or_lexile_array('grade'))
    end
  end
end
