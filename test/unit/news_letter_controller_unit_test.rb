# frozen_string_literal: true

require 'test_helper'
class NewsLetterControllerUnitTest < Minitest::Test

  extend Minitest::Spec::DSL
  include LogWrapper

  def setup
    @nl_controller = NewsLetterController.new
    @mintest_mock1 = Minitest::Mock.new
    @mintest_mock2 = Minitest::Mock.new
  end

  describe 'news-letter email already in google sheets?' do
    it 'news-letter email already in google sheets?' do
      emails_arr = ['test@test1.com', "test2@test2.com"]
      email = emails_arr[0]
      resp = assert_raises(RuntimeError) { @nl_controller.email_already_in_google_sheets?(emails_arr, email) }
      assert_equal("That email is already subscribed to the MyLibraryNYC newsletter.", resp.message)
    end

    it 'news-letter email not in google sheets' do
      emails_arr = ["test@gmail.com", "ujuj@ww.com"]
      email = "ujujq@ww.com"
      resp = @nl_controller.email_already_in_google_sheets?(emails_arr, email)
      assert_nil(resp)
    end
  end


  describe 'Test create news letter email in google_sheets method' do
    # # Case: 1
    it 'Test Decrypt news-letetr email method' do
      email = 'test@ss.com'
      params = {key: "edededede"}
      @mintest_mock1.expect(:call, ['test@ss.com'])
      resp = nil
      @nl_controller.stub :news_letter_google_spread_sheet_emails, @mintest_mock1 do
        EncryptDecryptString.stub :decrypt_string, email, [params['key']] do
          resp = @nl_controller.create_news_letter_email_in_google_sheets(params)
        end
      end
      assert_equal(true, resp)
      @mintest_mock1.verify
    end

    # # Case: 2
    it 'Test error while creating the news letter email in google sheets' do
      email = 'test@ss1.com'
      params = {key: "edededede"}
      @mintest_mock1.expect(:call, ['test@ss.com'])
      resp = nil
      @nl_controller.stub :news_letter_google_spread_sheet_emails, @mintest_mock1 do
        EncryptDecryptString.stub :decrypt_string, email, [params['key']] do
          resp = @nl_controller.create_news_letter_email_in_google_sheets(params)
        end
      end
      assert_equal(false, resp)
      @mintest_mock1.verify
    end

    # Case: 3
    it 'Test successfully create the news letter email in google sheets method' do
      email = 'test@ss1.com'
      params = { key: 'edededede' }
      google_sheet = Struct.new(:spreadsheet_id, :table_range).new('wed11', 'A1')
      @mintest_mock1.expect(:call, ['test@ss.com'])
      @mintest_mock2.expect(:call, google_sheet, [email])

      resp = nil
      @nl_controller.stub :news_letter_google_spread_sheet_emails, @mintest_mock1 do
        EncryptDecryptString.stub :decrypt_string, email, [params['key']] do
          @nl_controller.stub :write_news_letter_emails_to_google_sheets, @mintest_mock2 do
            resp = @nl_controller.create_news_letter_email_in_google_sheets(params)
          end
        end
      end
      assert_equal(true, resp)
      @mintest_mock1.verify
      @mintest_mock2.verify
    end
  end
end
