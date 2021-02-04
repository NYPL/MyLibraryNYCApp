# frozen_string_literal: true

require 'test_helper'

class HomeControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test 'test faq method' do
    get :faq
    assert_response :success
  end

  test 'test newsletter_confirmation' do
    get :newsletter_confirmation, params: {key: "ere"}
    assert_response :success
  end
end
