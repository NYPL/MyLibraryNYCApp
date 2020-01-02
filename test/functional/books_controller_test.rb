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

  # Assertion(assert_no_difference) that the result of evaluating an expression is not changed before and after invoking the passed in block.
  test "should create book" do
    assert_difference 'Book.count' do
      post :create, params: {book: {title: 'title', details_url: 'details_url'}}
    end
    assert_response :success
  end

end

