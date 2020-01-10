# frozen_string_literal: true

require 'test_helper'

class SchoolsControllerTest < ActionController::TestCase

  setup do
    @school = schools(:school_one)
  end

  test "should get index" do
    resp = get :index, :format => :json
    assert_response :success
  end

  test "should create school" do
    assert_difference 'School.count' do
      post :create, params: {school: {address_line_1: '@school.address_line_1', state: "@school.state", active: "@school.active"}}
    end
    assert_response :success
  end
end