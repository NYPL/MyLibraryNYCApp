# frozen_string_literal: true

require 'test_helper'
class FaqsControllerTest < MiniTest::Test

  extend Minitest::Spec::DSL
  include LogWrapper

  def setup
    @faq_controller = FaqsController.new
  end

  describe "test_teacher_sets_input_params" do
    it 'teacher sets input params' do
      resp = @faq_controller.frequently_asked_questions
      assert_empty(resp)
    end
  end
end