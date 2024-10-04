# frozen_string_literal: true

require 'test_helper'
class FaqsControllerTest < Minitest::Test

  extend Minitest::Spec::DSL
  include LogWrapper

  def setup
    @faq_controller = FaqsController.new
  end

  describe "test faqs" do
    it 'test faqs' do
      resp = @faq_controller.frequently_asked_questions
      assert_equal(2, resp.count)
    end
  end
end
