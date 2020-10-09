# frozen_string_literal: true

require("bundler")
Bundler.require

class GoogleSpreadSheet

  # Get google sheet credentials from ENV config and read news-letetr emails from good sheets.
  def google_sheet_client
    google_credentials = ENV['NEWS_LETTER_GOOGLE_CREDENTIALS']
    session = GoogleDrive::Session.from_service_account_key(StringIO.new(google_credentials))
    @spreadsheet = session.spreadsheet_by_title("MLN newsletter signup requests - development")
    @worksheet = @spreadsheet.worksheets.first
  rescue StandardError => e
    LogWrapper.log('ERROR', {'message' => "Error occcured while calling the google sheets. #{e.message}",
                             'method' => 'google_sheet_client'})
    raise "We've encountered an error and were unable to confirm your email"
  end

  
  # Create news-letter email into google sheets
  def create_news_letter_email_in_google_sheets(params)
    google_sheet_client
    email = params["email"]
    @worksheet.insert_rows(@worksheet.num_rows + 1, [[email]])
    #is_saved_in_google_sheets = @worksheet.save
    LogWrapper.log('INFO', {'message' => "Saved in google sheets  #{is_saved_in_google_sheets}, params: #{params}",
                            'method' => 'create_news_letter_email_in_google_sheets'})
  end
end
