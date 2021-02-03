# frozen_string_literal: true

require 'test_helper'
module Admin
  class BooksControllerTest < ActionController::TestCase
    setup do
      @book = books(:books_two)
      sign_in AdminUser.create!(email: 'admin@example.com', password: 'password')
    end

    test "test index method" do
      get :index
      assert_equal("200", response.code)
      assert_response :success
    end
    
    test "test show method" do
      get :show, params: { id: @book.id }
      assert_equal("200", response.code)
      assert_response :success
    end

    test "test show method with version param" do
      create_book_version
      get :show, params: { id: @book.id, version: 1 }
      assert_equal("200", response.code)
      assert_response :success
    end

    test "test history method" do
      create_book_version
      get :history, params: { id: @book.id }
      assert_equal("200", response.code)
      assert_response :success
    end

    private

    def create_book_version
      book = Book.find(@book.id)
      book.details_url = 'details_url'
      book.save!
    end
  end
end
