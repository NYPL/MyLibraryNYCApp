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
end
