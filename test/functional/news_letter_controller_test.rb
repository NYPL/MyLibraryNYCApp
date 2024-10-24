# frozen_string_literal: true

require 'test_helper'

class NewsLetterControllerTest < ActionController::TestCase
  test "should get index" do
    get 'index', params: {email: "ss@ss.com"}
    assert_response :success
  end
end
