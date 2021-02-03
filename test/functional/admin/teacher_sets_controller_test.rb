# frozen_string_literal: true

require 'test_helper'
module Admin
  class TeacherSetsControllerTest < ActionController::TestCase

    setup do
      @teacher_set = teacher_sets(:teacher_set_one)
      sign_in AdminUser.create!(email: 'admin@example.com', password: 'password')
    end

    test "test index method" do
      get :index
      assert_equal("200", response.code)
      assert_response :success
    end

    test "test show method" do
      get :show, params: { id: @teacher_set.id }
      assert_equal("200", response.code)
      assert_response :success
    end

    test "test make_available method with format js" do
      put :make_available, params: { id: @teacher_set.id }, format: :js
      assert_equal("200", response.code)
      assert_response :success
    end

    test "test make_available method" do
      put :make_available, params: { id: @teacher_set.id }
      assert_equal("302", response.code)
      assert_response :redirect
    end

    test "test make_unavailable method with format js" do
      put :make_unavailable, params: { id: @teacher_set.id }, format: :js
      assert_equal("200", response.code)
      assert_response :success
    end

    test "test make_unavailable method" do
      put :make_unavailable, params: { id: @teacher_set.id }
      assert_equal("302", response.code)
      assert_response :redirect
    end
  end
end
