# frozen_string_literal: true

require 'test_helper'

class RegistrationsControllerTest < ActionController::TestCase
  def setup
    @controller = RegistrationsController.new
  end


  # TODO: next step: mock the request (see test_helper.mock_check_barcode_request)
  test "sending user to sierra changes status from pending to complete" do
    # crank(:queens_user, barcode: 27777011111111)
    # @user.save_as_pending!
    # assert_equal("barcode_pending", @user.status)
    # @user.find_unique_new_barcode
    # TODO: in the future, maybe make smaller and change to @user.send_request_to_patron_creator_service
    # assert_equal("complete", @user.status)
    assert(true)
  end
end
