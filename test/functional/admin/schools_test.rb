# frozen_string_literal: true

require 'test_helper'
class SchoolsTest < ActionController::TestCase 

  setup do
    @school = schools(:school_one)
  end

  test 'index' do
    assert_routing '/admin/schools', controller: 'admin/schools', action: 'index'
  end

  test 'show' do
    assert_routing "/admin/schools/#{@school.id}", controller: 'admin/schools', action: 'show', id: @school.id.to_s
  end

  test 'history' do
    assert_routing "/admin/schools/#{@school.id}/history", controller: 'admin/schools', action: 'history', id: @school.id.to_s
  end

  test 'activate' do
    assert_routing({ method: 'put', path: "/admin/schools/#{@school.id}/activate" }, { controller: 'admin/schools', 
      action: 'activate', id: @school.id.to_s })
  end

  test 'in-activate' do
    assert_routing({ method: 'put', path: "/admin/schools/#{@school.id}/inactivate" }, { controller: 'admin/schools', 
      action: 'inactivate', id: @school.id.to_s })
  end
end
