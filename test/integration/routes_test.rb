# frozen_string_literal: true

require 'test_helper'

class RoutesTest < ActionDispatch::IntegrationTest

  test "test for sets index page" do
    assert_routing "/", :controller => "home", :action => "index"
  end

  test "test for info-site index page" do
    assert_routing "http://#{ENV['MLN_INFO_SITE_URL']}", get_params('index')
  end

  test "test for info-site participating-schools" do
    assert_routing "http://#{ENV['MLN_INFO_SITE_URL']}/about/participating-schools", get_params('participating_schools')
  end

  test "test for info-site about page" do
    assert_routing "http://#{ENV['MLN_INFO_SITE_URL']}/about/about-mylibrarynyc", get_params('about')
  end

  test "test for info-site contacts-links page" do
    assert_routing "http://#{ENV['MLN_INFO_SITE_URL']}/contacts-links", get_params('contacts')
  end

  test "test for info-ste digital resources page" do
    assert_routing "http://#{ENV['MLN_INFO_SITE_URL']}/help/access-digital-resources", get_params('digital_resources')
  end

  private

  def get_params(action_name)
    {:controller => "info_site", :action => action_name, :host => ENV['MLN_INFO_SITE_URL']}
  end
end
