# frozen_string_literal: true

require 'test_helper'

class FaqsControllerTest < Minitest::Test
  extend Minitest::Spec::DSL
  include LogWrapper

  def setup
    @faq_controller = FaqsController.new
  end
end
