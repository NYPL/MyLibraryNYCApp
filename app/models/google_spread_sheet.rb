# frozen_string_literal: true

require("bundler")
Bundler.require

class GoogleSpreadSheet

  # Get google sheet credentials from AwsParameterStore.
  def google_sheet_client
    client_secret_body = AwsParameterStoreController.new.google_sheet_credentials
    session = GoogleDrive::Session.from_service_account_key(StringIO.new(JSON.dump(client_secret_body)))
    @spreadsheet = session.spreadsheet_by_title("MLN newsletter signup requests - #{ENV[RAILS_ENV]}")
    @worksheet = @spreadsheet.worksheets.first
  end

  
  # Create news-letter email into google sheets
  def create_news_letter_email_in_google_sheets(params)
    google_sheet_client
    new_row = params["email"]
    @worksheet.insert_rows(@worksheet.num_rows + 1, [[new_row]])
    is_saved_in_google_sheets = @worksheet.save
    LogWrapper.log('INFO', {'message' => "Saved in google sheets  #{is_saved_in_google_sheets}",
                            'method' => 'create_news_letter_email_in_google_sheets'})
    
  end
end
