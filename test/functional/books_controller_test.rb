# frozen_string_literal: true

require 'test_helper'

class BooksControllerTest < ActionController::TestCase

  setup do
    @book = books(:books_one)
  end

  test "should show books" do
    get :show, params: { id: @book.id }
    assert_response :success
  end

  test "should create book" do
    assert_difference 'Book.count' do
      post :create, params: {book: {title: 'title', details_url: 'details_url'}}
    end
    assert_response :success
  end

  test "test book strong params" do
    post :create, { id: 1}
    assert_response :success
  end

end
