# frozen_string_literal: true

require 'test_helper'

class ApplicationControllerTest < ActionController::TestCase

  test "should test require login" do
    post :require_login
    assert_response :redirect
  end

  test "test redirect to angular" do
    post :redirect_to_angular
    assert_response :redirect
  end
end
