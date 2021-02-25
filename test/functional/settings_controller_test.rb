# frozen_string_literal: true

require 'test_helper'

class SettingsControllerTest < ActionController::TestCase

  setup do
    @user = users(:user1)
    @school = schools(:school_one)
  end

  test "test index method with current_user" do
    sign_in @user
    get :index, params: { settings: { contact_email: "test@gmail.com", school: { id: @school.id } } }
    assert_response :success
  end

  test "test index method with out current_user" do
    get :index, params: { settings: { contact_email: "test@gmail.com", school: { id: @school.id } } }
    assert_equal("You must be logged in to access this page", flash[:error])
    assert_response :redirect
  end
end
