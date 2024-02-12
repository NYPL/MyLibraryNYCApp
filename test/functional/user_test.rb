# frozen_string_literal: true

require 'test_helper'
require 'pry'

class UserTest < ActionController::TestCase

  setup do
    @user = users(:user1)
  end
  
  # Method: calculate_next_recurring_event_date
  # Be default next recurring event_date date is june 30.
  test 'current_date is June 30' do
    month = 6
    day = 30
    current_date =  Date.today
    expected_output = Date.new(current_date.year, month, day).strftime('%Y-%m-%d')
    # Check if it's on June 30th
    resp = @user.calculate_next_recurring_event_date(month, day)
    assert_equal(expected_output, resp)
  end

  test 'current_date is after June 30 add subsequent year' do
    month = 7
    day = 30
    expected_output = Date.new(Date.today.year + 1, month, day).strftime('%Y-%m-%d')
    # Check if it's on June 30th
    resp = @user.calculate_next_recurring_event_date(month, day)
    assert_equal(expected_output, resp)
  end

  test 'current_date is before June 30' do
    month = 2
    day = 30
    expected_output = Date.new(Date.today.year, month, day).strftime('%Y-%m-%d')
    # Check if it's before June 30th
    resp = @user.calculate_next_recurring_event_date(month, day)
    assert_equal(expected_output, resp)
  end
end
