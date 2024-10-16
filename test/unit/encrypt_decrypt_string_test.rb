# frozen_string_literal: true

require 'test_helper'
class EncryptDecryptStringTest < Minitest::Test

  extend Minitest::Spec::DSL
  include LogWrapper
  include EncryptDecryptString

  def setup
    @encrypt_string = "test@gmail.com"
    @decrypt_string = 'F801CD4E130FC0EBB0A00533F01B19F3'
  end

  def test_encrypt_string
    resp = EncryptDecryptString.encrypt_string(@encrypt_string)
    assert_equal(@decrypt_string, resp)
  end

  def test_decrypt_string
    resp = EncryptDecryptString.decrypt_string(@decrypt_string)
    assert_equal(@encrypt_string, resp)
  end
end
