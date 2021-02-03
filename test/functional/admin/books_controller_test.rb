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
      assert_response :success
    end
    
    test "test show method" do
      get :show, params: { id: @book.id }
      assert_response :success
    end
  end
end
