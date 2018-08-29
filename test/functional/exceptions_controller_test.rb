require 'test_helper'

class ExceptionsControllerTest < ActionController::TestCase
  test 'render_error' do
    get :render_error
    assert response.body.include? "We've encountered an error."
  end
end
