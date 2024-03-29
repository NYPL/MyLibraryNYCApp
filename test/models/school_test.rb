# frozen_string_literal: true

require 'test_helper'

class SchoolTest < ActionController::TestCase

  setup do
    @school1 = schools(:school_one)
    @school3 = schools(:school_three)
    @school4 = schools(:school_four)
  end

  test 'test all active schools' do
    resp = School.active_schools_data
    assert_equal(3, resp.count)
  end

  test 'test inactive school' do
    resp = @school4.name_id
    assert_equal("[INACTIVE] #{@school4.name} (#{@school4.code[1..].upcase})", resp[0])
    assert_equal(@school4.id, resp[1])
  end

  test 'test with school code value' do
    resp = @school1.school_code
    assert_equal(" (38227442)", resp)
  end

  test 'test with-out school code value' do
    @school3.school_code
    resp = @school3.school_code
    assert_empty(resp)
  end
end
