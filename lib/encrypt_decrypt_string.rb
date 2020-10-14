# frozen_string_literal: true

require 'openssl'

module EncryptDecryptString
  def self.encrypt_string(str)
    cipher_salt1 = 'my-library-nyc'
    cipher_salt2 = 'nypl'
    cipher = OpenSSL::Cipher.new('AES-128-ECB').encrypt
    cipher.key = OpenSSL::PKCS5.pbkdf2_hmac_sha1(cipher_salt1, cipher_salt2, 20_000, cipher.key_len)
    encrypted = cipher.update(str) + cipher.final
    encrypted.unpack1('H*').upcase
  end

  def self.decrypt_string(encrypted_str)
    cipher_salt1 = 'my-library-nyc'
    cipher_salt2 = 'nypl'
    cipher = OpenSSL::Cipher.new('AES-128-ECB').decrypt
    cipher.key = OpenSSL::PKCS5.pbkdf2_hmac_sha1(cipher_salt1, cipher_salt2, 20_000, cipher.key_len)
    decrypted = [encrypted_str].pack('H*').unpack('C*').pack('c*')
    cipher.update(decrypted) + cipher.final
  end
end
