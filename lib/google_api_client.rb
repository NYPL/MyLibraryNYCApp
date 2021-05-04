# frozen_string_literal: true

require 'google/apis/drive_v3'
require 'googleauth'
require 'google/apis/analytics_v3'
require 'google/apis/sheets_v4'

module GoogleApiClient
  # Connect's to google sheet client
  def self.sheets_client
    auth_drive
    client = Google::Apis::SheetsV4::SheetsService.new
    scope = Google::Apis::SheetsV4::AUTH_SPREADSHEETS
    client.authorization = Google::Auth.get_application_default(scope)
    client
  end


  def self.drive_client
    json = JSON.parse(ENV['NEWS_LETTER_GOOGLE_CREDENTIALS'])
    ENV["GOOGLE_ACCOUNT_TYPE"] = 'service_account'
    ENV["GOOGLE_CLIENT_EMAIL"] = json["client_email"]
    ENV["GOOGLE_PRIVATE_KEY"] = json["private_key"]
    client = Google::Apis::DriveV3::DriveService.new
    scope = Google::Apis::DriveV3::AUTH_DRIVE
    client.authorization = Google::Auth.get_application_default(scope)
    client
  end

  def auth_drive
    json = JSON.parse(ENV['NEWS_LETTER_GOOGLE_CREDENTIALS'])
    ENV["GOOGLE_ACCOUNT_TYPE"] = 'service_account'
    ENV["GOOGLE_CLIENT_EMAIL"] = json["client_email"]
    ENV["GOOGLE_PRIVATE_KEY"] = json["private_key"]
  end
end
