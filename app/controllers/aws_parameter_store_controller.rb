# frozen_string_literal: true

class AwsParameterStoreController

  def initialize
    @current_file = File.basename(__FILE__)
    @systems_manager = create_client
  end

  
  # Call AWS parameter store to get google-sheet credential values.
  def get_parameter_store_values(parameter_name)
    begin
      response = @systems_manager.get_parameter({
        name: parameter_name,
        with_decryption: true
      })
      LogWrapper.log('INFO', {'message' => "AWS parameter call  #{response}",
                              'method' => 'get_parameter_store_values'})
      response_body = response.parameter
    rescue Aws::Errors::ServiceError => e
      raise e
    end
    response_body
  end


  def news_letter_google_sheet_credentials
    get_parameter_store_values("/#{ENV['RAILS_ENV']}/google-credentials/mylibrarynyc")
  end


  def google_sheet_credentials
    begin
      client_secret_body = news_letter_google_sheet_credentials
      JSON.parse client_secret_body.value if client_secret_body.present?
    rescue Aws::Errors::ServiceError => e
      LogWrapper.log('ERROR', {'message' => "Error occured while reading the google credentials from aws parameter store. #{e.message}", 
                     'method' => 'google_sheet_credentials'})
      raise e
    end
  end


  private

  def create_client
    client_options = {
      region: 'us-east-1'
    }
    @systems_manager = Aws::SSM::Client.new(client_options)
    @systems_manager
  end
end
