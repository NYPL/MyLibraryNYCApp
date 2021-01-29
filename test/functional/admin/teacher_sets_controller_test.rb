# frozen_string_literal: true

require 'test_helper'

class Admin::TeacherSetsControllerTest < ActionController::TestCase

  setup do
    @teacher_set = teacher_sets(:teacher_set_one)
    sign_in AdminUser.create!(email: 'admin@example.com', password: 'password')
  end

  test "test index method" do
    get :index
  end

  test "test show method" do
    get :show, params: { id: @teacher_set.id }
  end

  test "test make_available method" do
    put :make_available, params: { id: @teacher_set.id }
  end

  test "test make_unavailable method" do
    put :make_unavailable, params: { id: @teacher_set.id }
  end
end
