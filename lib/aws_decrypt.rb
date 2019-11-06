module AwsDecrypt

	def self.decrypt_kms(key)
		client = Aws::KMS::Client.new(region: 'us-east-1')
    puts "AwsDecrypt.decrypt_kms: about to decrypt, key=#{key or 'empty_key'}"
		resp = client.decrypt({
			ciphertext_blob: Base64.decode64(key)
			})
    puts "AwsDecrypt.decrypt_kms: decrypted, key=#{resp.plaintext or 'empty_resp'}"
		return resp.plaintext
	end

end
