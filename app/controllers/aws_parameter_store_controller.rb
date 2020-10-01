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
        with_decryption: false
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
    get_parameter_store_values("/#{ENV[RAILS_ENV]}/google-credentials/mylibrarynyc")
  end


  def google_sheet_credentials
    client_secret_body = news_letter_google_sheet_credentials
    JSON.parse client_secret_body.value if client_secret_body.present?
  end


  private

  def create_client
    client_options = {
      region: 'us-east-1'
    }
    @systems_manager = Aws::SSM::Client.new(client_options)
    LogWrapper.log('INFO', {'message' => "TEST LOG TEST TEST #{@systems_manager} TEST LOG TEST TEST", 'method' => 'create_client'})
    @systems_manager
  end
end
