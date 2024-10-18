# frozen_string_literal: true

require 'test_helper'

class RoutesTest < ActionDispatch::IntegrationTest

  test "test for home index page" do
    assert_routing "http://#{ENV.fetch('MLN_INFO_SITE_HOSTNAME', nil)}",
                   get_action_params('home', 'index')
  end

  test "test for schools participating-schools" do
    assert_routing "http://#{ENV.fetch('MLN_INFO_SITE_HOSTNAME', nil)}/participating-schools",
                   get_action_params('schools', 'participating_schools_data')
  end

  test "test for home contacts page" do
    assert_routing "http://#{ENV.fetch('MLN_INFO_SITE_HOSTNAME', nil)}/contact",
                   get_action_params('home', 'help')
  end

  test "test for info-ste digital resources page" do
    assert_routing "http://#{ENV.fetch('MLN_INFO_SITE_HOSTNAME', nil)}/help/access-digital-resources",
                   get_action_params('home' , 'digital_resources')
  end

  private

  def get_action_params(controller, action_name)
    {
      :controller => controller,
      :action => action_name
    }
  end
end
