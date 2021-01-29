# frozen_string_literal: true

require 'test_helper'
require 'pry'

class Admin::SchoolsControllerTest < ActionController::TestCase

  setup do
    @school = schools(:school_one)
    sign_in AdminUser.create!(email: 'admin@example.com', password: 'password')
  end

  test "test index method" do
    get :index
    assert_response :success
  end

  test "test show method" do
    get :show, params: { id: @school.id }
    assert_response :success
  end

  test "test activate method" do
    put :activate, params: { id: @school.id }
    assert_response :redirect
  end

  test "test inactivate method" do
    put :inactivate, params: { id: @school.id }
    assert_response :redirect
  end
end
