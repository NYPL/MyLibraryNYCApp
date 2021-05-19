# frozen_string_literal: true

require 'google/apis/drive_v3'
require 'googleauth'
require 'google/apis/analytics_v3'
require 'google/apis/sheets_v4'

module GoogleApiClient
  # Connect's to google sheet client
  def self.sheets_client
    client = Google::Apis::SheetsV4::SheetsService.new
    client.authorization = auth_sheet
    client
  end

  # Connect's to google drive client
  def self.drive_client
    client = Google::Apis::DriveV3::DriveService.new
    client.authorization = auth_drive
    client
  end

  def self.auth_sheet
    auth(scope: Google::Apis::SheetsV4::AUTH_SPREADSHEETS)
  end

  def self.auth_drive
    auth(scope: Google::Apis::DriveV3::AUTH_DRIVE)
  end


  def self.auth(scope)
    json = JSON.parse(ENV['MLN_GOOGLE_ACCCOUNT']) || {}
    ENV["GOOGLE_ACCOUNT_TYPE"] = 'service_account'
    ENV["GOOGLE_CLIENT_EMAIL"] = json["client_email"]
    ENV["GOOGLE_PRIVATE_KEY"] = json["private_key"]
    Google::Auth.get_application_default(scope)
  end


  def self.export_file(document_id, format)
    client = drive_client
    client.export_file(document_id, format)
  end
end
