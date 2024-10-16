# frozen_string_literal: true

require 'test_helper'

class HomeControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test 'test faq data method' do
    get :faq_data
    assert_response :success
  end

  test 'test newsletter_confirmation' do
    get :newsletter_confirmation, params: {key: "ere"}
    assert_response :success
  end
end
