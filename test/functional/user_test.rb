# frozen_string_literal: true

require 'test_helper'

class UserTest < ActionController::TestCase

  setup do
    @user = users(:user1)
  end
  
  JUNE_30 = Date.new(Date.today.year, 6, 30)
  # Method: calculate_next_recurring_event_date
  # By default next recurring event_date date is june 30.
  test 'It should return next year if date is June 30' do
    month = 6
    day = 30
    # Check if it's on June 30th
    current_date = JUNE_30
    expected_output = (JUNE_30 + 1.year).strftime('%Y-%m-%d')
    resp = @user.calculate_next_recurring_event_date(current_date)
    assert_equal(expected_output, resp)
  end

  test 'It should return next year if date is after June 30' do
    month = 7
    day = 30
    # Check if it's after June 30th
    current_date = Date.new(Date.today.year, month, day)
    expected_output =(JUNE_30 + 1.year).strftime('%Y-%m-%d')
    resp = @user.calculate_next_recurring_event_date(current_date)
    assert_equal(expected_output, resp)
  end

  test 'It should return current year if date is before June 30' do
    month = 2
    day = 28
    # Check if it's before June 30th
    current_date = Date.new(Date.today.year, month, day)
    expected_output = JUNE_30.strftime('%Y-%m-%d')
    resp = @user.calculate_next_recurring_event_date(current_date)
    assert_equal(expected_output, resp)
  end
end
