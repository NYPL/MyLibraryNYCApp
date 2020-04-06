class S3Controller < ApplicationController

  def initialize
    @current_file = File.basename(__FILE__)
    @s3_client = create_client
  end

  def get_s3_file(bucket, file)
    start_time = Time.now
    begin
      response = @s3_client.get_object({
        bucket: bucket,
        key: file
      })
      response_body = response.body.read
    rescue Aws::Errors::ServiceError => e
      raise e
    end
    response_body
  end

  private

  def create_client
    client_options = {
        region: 'us-east-1'
    }
    Aws::S3::Client.new(client_options)
  end
end