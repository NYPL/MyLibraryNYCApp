# frozen_string_literal: true

require 'test_helper'
class NewsLetterControllerUnitTest < MiniTest::Test

  extend Minitest::Spec::DSL
  include LogWrapper

  def setup
    @nl_controller = NewsLetterController.new
    @mintest_mock1 = MiniTest::Mock.new
    @mintest_mock2 = MiniTest::Mock.new
  end

  describe 'Test news-letter email found in google sheets ' do
    it 'Test news-letter email found in google sheets' do
      emails_arr = ['test@test1.com', "test2@test2.com"]
      email = emails_arr[0]
      resp = assert_raises(RuntimeError) { @nl_controller.email_already_in_google_sheets?(emails_arr, email) }
      assert_equal("Email is already subscribed.", resp.message)
    end
  end
end
