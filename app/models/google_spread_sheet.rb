# frozen_string_literal: true

require("bundler")
Bundler.require

class GoogleSpreadSheet

  # Get google sheet credentials from AwsParameterStore.
  def google_sheet_client
    google_credentials = ENV['NEWS_LETTER_GOOGLE_CREDENTIALS']
    session = GoogleDrive::Session.from_service_account_key(StringIO.new(google_credentials))
    @spreadsheet = session.spreadsheet_by_title("MLN newsletter signup requests - #{ENV['RAILS_ENV']}")
    @worksheet = @spreadsheet.worksheets.first
  rescue StandardError => e
    LogWrapper.log('ERROR', {'message' => "Error occcured while calling the google sheets. #{e.message}",
                             'method' => 'google_sheet_client'})
    raise "We've encountered an error and were unable to confirm your email"
  end

  
  # This method checks input email is already in google sheets or not.
  # If email is not in google sheets, it will create email in google sheets
  def create_news_letter_email_in_google_sheets(params)
    google_sheet_client
    email = params["email"]
    if email_already_in_google_sheets?(email)
      LogWrapper.log('ERROR', {'message' => "Email already saved in google sheets. Email: #{email}",
                               'method' => 'create_news_letter_email_in_google_sheets'})
      raise 'Email is already subscribed.'
    end 
    @worksheet.insert_rows(@worksheet.num_rows + 1, [[email]])
    is_saved_in_google_sheets = @worksheet.save
    LogWrapper.log('INFO', {'message' => "Saved in google sheets  #{is_saved_in_google_sheets}, params: #{params}",
                            'method' => 'create_news_letter_email_in_google_sheets'})
  end

  
  # Checking here input email already in google sheets or not.
  def email_already_in_google_sheets?(input_email)
    emails_arr = @worksheet.rows.flatten
    emails_arr.include?(input_email)
  end
end
