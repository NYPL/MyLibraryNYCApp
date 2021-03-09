# frozen_string_literal: true

require 'test_helper'

class SchoolTest < ActionController::TestCase

  setup do
    @school1 = schools(:school_one)
    @school3 = schools(:school_three)
  end

  test 'test all active schools' do
    resp = School.active_schools
    assert_equal(3, resp.count)
  end

  test 'test inactive school' do
    resp = School.inactive_school(@school1)
    assert_equal("[INACTIVE] #{@school1.name} (#{@school1.code[1..-1].upcase})", resp[0])
    assert_equal(@school1.id, resp[1])
  end

  test 'test with school code value' do
    resp = School.school_code(@school1)
    assert_equal(" (#{@school1.code[1..-1].upcase})", resp)
  end

  test 'test with-out school code value' do
    resp = School.school_code(@school3)
    assert_empty(resp)
  end
end
