# frozen_string_literal: true

require 'test_helper'
require 'minitest/stub_any_instance'

module Admin
  class DocumentsControllerTest < ActionController::TestCase

    setup do
      @document = documents(:one)
      @document2 = documents(:two)
      sign_in AdminUser.create!(email: 'admin@example.com', password: 'password')
    end


    test "test index method" do
      get :index
      assert_equal("200", response.code)
      assert_response :success
    end


    test "test show method" do
      response = get :show, params: { id: @document.id }
      assert_equal("200", response.code)
      assert_response :success
    end


    test 'Test document form ' do
      response = get :edit, params: { id: @document.id }
      assert_equal("200", response.code)
      assert_response :success
    end


    test 'create calendar_of_event in mln database' do
      params = {"event_type" => "calendar_of_events_test", "file_name" => "MylibraryNycCalenderevent123", 
                "url" => "https://docs.google.com/document/d/1iBzIYM_GG5OCXkuF4vKwSYRFaH3gd8Q_kuDrqT7Iu4U/edit" }
      file = "test file"
      Document.stub_any_instance :google_document, file do
        post :create, params: { document: params }
      end
      document = Document.where(file: file)
      assert_equal(file, document.file)
      assert_response :success
    end


    test 'test download mylibrarynyc pdf method' do
      get :download_pdf, params: { format: @document.id }
      assert_response :success
    end
  end
end
