# frozen_string_literal: true

require 'test_helper'
require 'pry'
class Admin::FaqsControllerTest < ActionController::TestCase

  setup do
    @faq = faqs(:one)
    sign_in AdminUser.create!(email: 'admin@example.com', password: 'password')
  end

  test "test index method" do
    get :index
    assert_response :success
  end

  test "test show method" do
    get :show, params: { id: @faq.id}
    assert_response :success
  end

  test 'test edit method' do
    get :edit, id: @faq.id
    assert_response :success
  end


end
