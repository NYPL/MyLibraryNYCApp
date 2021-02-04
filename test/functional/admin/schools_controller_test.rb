# frozen_string_literal: true

require 'test_helper'
require 'pry'
module Admin
  class SchoolsControllerTest < ActionController::TestCase

    setup do
      @school = schools(:school_one)
      sign_in AdminUser.create!(email: 'admin@example.com', password: 'password')
    end

    test "test index method" do
      get :index
      assert_equal("200", response.code)
      assert_response :success
    end

    test "test show method" do
      get :show, params: { id: @school.id }
      assert_equal("200", response.code)
      assert_response :success
    end

    test "test show method with version param" do
      create_school_version
      get :show, params: { id: @school.id, version: 1 }
      assert_equal("200", response.code)
      assert_response :success
    end

    test "test activate method" do
      put :activate, params: { id: @school.id }
      assert_equal("302", response.code)
      assert_response :redirect
    end

    test "test activate method with format js" do
      put :activate, params: { id: @school.id }, format: :js
      assert_equal("200", response.code)
      assert_response :success
    end

    test "test inactivate method" do
      put :inactivate, params: { id: @school.id }
      assert_equal("302", response.code)
      assert_response :redirect
    end

    test "test inactivate method with format js" do
      put :inactivate, params: { id: @school.id }, format: :js
      assert_equal("200", response.code)
      assert_response :success
    end

    test "test history method" do
      create_school_version
      get :history, params: { id: @school.id }
      assert_equal("200", response.code)
      assert_response :success
    end

    private

    def create_school_version
      school = School.find(@school.id)
      school.phone_number = '324532222'
      school.save!
    end
  end
end
