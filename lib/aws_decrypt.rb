# frozen_string_literal: true

module AwsDecrypt

  def self.decrypt_kms(key)
    client = Aws::KMS::Client.new(region: 'us-east-1')
    resp = client.decrypt({
      ciphertext_blob: Base64.decode64(key)
      })
    return resp.plaintext
  end

end
