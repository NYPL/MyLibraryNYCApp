require 'test_helper'
require 'minitest/spec'
require 'minitest/autorun'

class ApplicationHelperTest < MiniTest::Test
  include ApplicationHelper

  def setup
  end

  def test_custom_devise_error_messages
    error_msg_hash  = {:alt_email=>["Alternate email has already been taken"], 
                   :pin=>["PIN does not meet our requirements. Please try again."]}
    resp = custom_devise_error_messages(error_msg_hash)
  end
  
  def resource_object
    errors = {}
    errors[:messages] = {:alt_email=>["has already been taken"], :pin=>["does not meet our requirements. Please try again."]} 
    OpenStruct.new(id: 1, email: 'test@email.com', errors: errors)
  end

end
