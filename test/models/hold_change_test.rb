# frozen_string_literal: true

require 'test_helper'

class HoldChangeTest < ActionController::TestCase

  setup do
    @hold_changes1 = hold_changes(:hold_changes1)
    @hold_changes2 = hold_changes(:hold_changes2)
    @hold2 = holds(:hold2)
  end

  test 'Update status of the hold' do
    # Hold status is 'new' before update
    assert_equal("new", @hold2.status)

    @hold2.status = 'cancel'
    @hold_changes1.send(:update_hold)
    # Hold status is 'cancel' after update
    assert_equal("cancel", @hold2.status)
  end

  test 'send hold change status email' do
    # hold_change status should be ['error', 'pending', 'closed', 'cancelled'] than only sending status email.
    @hold_changes1.status = 'closed'
    resp = @hold_changes1.send(:send_change_status_email)
    assert_equal("Order closed | Your teacher set order for MyString1", resp.subject)

    # hold_change status is new not sending email
    @hold_changes1.status = 'new'
    resp = @hold_changes1.send(:send_change_status_email)
    assert_nil(resp)
  end

  test 'send hold teacher_set deleted email' do
    @hold_changes1.status = 'closed'
    resp = @hold_changes1.send(:send_teacher_set_deleted_email)
    assert_equal("Order closed | The Teacher Set you requested has been deleted", resp.subject)
  end

  test 'send email after saving the hold_change' do
    # test1 : Send status change email If Teacher-set is available
    @hold_changes1.status = 'closed'
    resp = @hold_changes1.do_after_save
    assert_equal("Order closed | Your teacher set order for MyString1", resp.subject)

    # test2 : Send deleted teacher-set notification email If Teacher-set is not available
    @hold_changes2.status = 'closed'
    resp2 = @hold_changes2.do_after_save
    assert_equal("Order closed | The Teacher Set you requested has been deleted", resp2.subject)
  end
end
