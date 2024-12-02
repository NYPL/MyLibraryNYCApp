# frozen_string_literal: true

require 'test_helper'

class SettingsControllerTest < ActionController::TestCase

  setup do
    @user = users(:user1)
    @user3 = users(:user3)
    @school = schools(:school_one)
    @school3 = schools(:school_three)
  end

  test "test index method with current_user" do
    sign_in @user
    get :index, params: { settings: { contact_email: "test@gmail.com", school: { id: @school.id } } }
    assert_response :success
  end

  test "test index method with out current_user" do
    get :index, params: { settings: { contact_email: "test@gmail.com", school: { id: @school.id } } }
    assert_equal("You must be logged in to access this page", flash[:error])
    assert_response :success # Changed because no double render is allowed @JC 2024-10-08
  end

  test "test index method with out school code" do
    sign_in @user3
    get :index, params: { settings: { contact_email: "test@gmail.com", school: { id: @school3.id } } }
    assert_response :success
  end
end
