# frozen_string_literal: true

require 'test_helper'
module Admin
  class DashboardControllerTest < ActionController::TestCase

    setup do
      @user = users(:user1)
      sign_in AdminUser.create!(email: 'admin@example.com', password: 'password')
    end

    test "test index method with call_number descending param" do
      get :index, params: {order: 'call_number_desc'}
      assert_response :success
    end

    test "test index method with p_call_number_desc param" do
      get :index, params: {order: 'p_call_number_desc'}
      assert_response :success
    end

    test "test index method with p_call_number_asc param" do
      get :index, params: {order: 'p_call_number_asc'}
      assert_response :success
    end

    test "test index method with p_user_desc param" do
      get :index, params: {order: 'p_user_desc'}
      assert_response :success
    end

    test "test index method with p_user_asc param" do
      get :index, params: {order: 'p_user_asc'}
      assert_response :success
    end

    test "test index method with p_barcode_asc param" do
      get :index, params: {order: 'p_barcode_asc'}
      assert_response :success
    end

    test "test index method with p_barcode_desc param" do
      get :index, params: {order: 'p_barcode_desc'}
      assert_response :success
    end

    test "test index method with p_school_asc param" do
      get :index, params: {order: 'p_school_asc'}
      assert_response :success
    end

    test "test index method with p_school_desc param" do
      get :index, params: {order: 'p_school_desc'}
      assert_response :success
    end

    test "test index method with p_set_asc param" do
      get :index, params: {order: 'p_set_asc'}
      assert_response :success
    end

    test "test index method with p_set_desc param" do
      get :index, params: {order: 'p_set_desc'}
      assert_response :success
    end

    test "test index method with p_created_at_asc param" do
      get :index, params: {order: 'p_created_at_asc'}
      assert_response :success
    end

    test "test index method with p_created_at_desc param" do
      get :index, params: {order: 'p_created_at_desc'}
      assert_response :success
    end

    test "test index method with p_quantity_asc param" do
      get :index, params: {order: 'p_quantity_asc'}
      assert_response :success
    end

    test "test index method with p_quantity_desc param" do
      get :index, params: {order: 'p_quantity_desc'}
      assert_response :success
    end

    test "test index method with school_desc param" do
      get :index, params: {order: 'school_desc'}
      assert_response :success
    end

    test "test index method with school_asc param" do
      get :index, params: {order: 'school_asc'}
      assert_response :success
    end

    test "test index method with user_desc param" do
      get :index, params: {order: 'user_desc'}
      assert_response :success
    end

    test "test index method with user_asc param" do
      get :index, params: {order: 'user_asc'}
      assert_response :success
    end

    test "test index method with barcode_asc param" do
      get :index, params: {order: 'barcode_asc'}
      assert_response :success
    end

    test "test index method with barcode_desc param" do
      get :index, params: {order: 'barcode_desc'}
      assert_response :success
    end

    test "test index method with call_number_asc param" do
      get :index, params: {order: 'call_number_asc'}
      assert_response :success
    end

    test "test index method with call_number_desc param" do
      get :index, params: {order: 'call_number_desc'}
      assert_response :success
    end

    test "test index method with set_asc param" do
      get :index, params: {order: 'set_asc'}
      assert_response :success
    end

    test "test index method with set_desc param" do
      get :index, params: {order: 'set_desc'}
      assert_response :success
    end

    test "test index method with created_at_asc param" do
      get :index, params: {order: 'created_at_asc'}
      assert_response :success
    end

    test "test index method with created_at_desc param" do
      get :index, params: {order: 'created_at_desc'}
      assert_response :success
    end

    test "test index method with quantity_asc param" do
      get :index, params: {order: 'quantity_asc'}
      assert_response :success
    end

    test "test index method with quantity_desc param" do
      get :index, params: {order: 'quantity_desc'}
      assert_response :success
    end
  end
end
