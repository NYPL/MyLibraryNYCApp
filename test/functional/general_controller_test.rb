# frozen_string_literal: true

require 'test_helper'

class GeneralControllerTest < ActionController::TestCase
  test "should get schools" do
    get :schools
    assert_response :success
  end

end
