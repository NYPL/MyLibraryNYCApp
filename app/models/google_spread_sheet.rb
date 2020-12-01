# frozen_string_literal: true

require("bundler")
Bundler.require

class GoogleSpreadSheet

  # Get google sheet credentials from application.yml and connect to google sheets.
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


  def get_news_letter_google_spread_sheets_emails
    google_sheet = JSON.parse(ENV['NEWS_LETTER_GOOGLE_CREDENTIALS'])

    ENV["GOOGLE_ACCOUNT_TYPE"] = 'service_account'
    ENV["GOOGLE_CLIENT_EMAIL"] = google_sheet["client_email"]
    ENV["GOOGLE_PRIVATE_KEY"] = google_sheet["private_key"]

    scope = Google::Apis::SheetsV4::AUTH_SPREADSHEETS
    authorization = Google::Auth.get_application_default(scope)
    # Initialize the API
    service = Google::Apis::SheetsV4::SheetsService.new
    service.authorization = authorization

    spreadsheet_id = ENV['NEWS_LETTER_GOOGLE_SPREAD_SHEET_ID']

    sheet_name = 'Sheet1'
    range = "#{sheet_name}!A1:B"
    response = service.get_spreadsheet_values(spreadsheet_id, range)
  end
end
