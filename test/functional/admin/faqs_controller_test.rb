# frozen_string_literal: true

require 'test_helper'
module Admin
  class FaqsControllerTest < ActionController::TestCase

    setup do
      @faq = faqs(:one)
      @faq2 = faqs(:two)
      sign_in AdminUser.create!(email: 'admin@example.com', password: 'password')
    end

    test "test index method" do
      response = get :index
      assert_equal("200", response.code)
      assert_response :success
    end

    test "test show method" do
      response = get :show, params: { id: @faq.id}
      assert_equal("200", response.code)
      assert_response :success
    end

    test 'test edit method' do
      response = get :edit, id: @faq.id
      assert_equal("200", response.code)
      assert_response :success
    end
  end
end
