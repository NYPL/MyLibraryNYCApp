# frozen_string_literal: true

require 'test_helper'

class RegistrationsControllerTest < ActiveSupport::TestCase

  extend Minitest::Spec::DSL
  include LogWrapper

  before do
    @controller = RegistrationsController.new
    @mintest_mock1 = MiniTest::Mock.new
    @mintest_mock2 = MiniTest::Mock.new
  end
end
