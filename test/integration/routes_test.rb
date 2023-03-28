# frozen_string_literal: true

require 'test_helper'

class RoutesTest < ActionDispatch::IntegrationTest
  NO_ROUTE_MATCHES = "No route matches"

  test "test for sets index page" do
    assert_routing "/", :controller => "home", :action => "index"
  end

  test "test for sets index page with sets hostname" do
    assert_routing "http://#{ENV.fetch('MLN_SETS_SITE_HOSTNAME', nil)}", :controller => "home", :action => "index"
  end

  test "test for info-site index page" do
    assert_routing "http://#{ENV.fetch('MLN_INFO_SITE_HOSTNAME', nil)}", get_info_site_action_params('index')
  end

  test "test for info-site participating-schools" do
    assert_routing "http://#{ENV.fetch('MLN_INFO_SITE_HOSTNAME', nil)}/about/participating-schools", 
                   get_info_site_action_params('participating_schools')
  end

  test "test for info-site participating-schools page with sets hostname" do
    resp = assert_raises ActionController::RoutingError do
      Rails.application.routes.recognize_path("http://#{ENV.fetch('MLN_SETS_SITE_HOSTNAME', nil)}/about/participating-schools")
    end
    assert_equal(true, resp.message.include?(NO_ROUTE_MATCHES))
  end

  test "test for info-site about page" do
    assert_routing "http://#{ENV.fetch('MLN_INFO_SITE_HOSTNAME', nil)}/about/about-mylibrarynyc", get_info_site_action_params('about')
  end

  test "test for info-site about page with sets hostname" do
    resp = assert_raises ActionController::RoutingError do
      Rails.application.routes.recognize_path("http://#{ENV.fetch('MLN_SETS_SITE_HOSTNAME', nil)}/about/about-mylibrarynyc")
    end
    assert_equal(true, resp.message.include?(NO_ROUTE_MATCHES))
  end

  test "test for info-site contacts-links page" do
    assert_routing "http://#{ENV.fetch('MLN_INFO_SITE_HOSTNAME', nil)}/contacts-links", get_info_site_action_params('contacts')
  end

  test "test for info-site contacts-links page with sets hostname" do
    resp = assert_raises ActionController::RoutingError do
      Rails.application.routes.recognize_path("http://#{ENV.fetch('MLN_SETS_SITE_HOSTNAME', nil)}/contacts-links")
    end
    assert_equal(true, resp.message.include?(NO_ROUTE_MATCHES))
  end

  test "test for info-ste digital resources page" do
    assert_routing "http://#{ENV.fetch('MLN_INFO_SITE_HOSTNAME', nil)}/help/access-digital-resources", 
                   get_info_site_action_params('digital_resources')
  end

  test "test for info-site digital resources page page with sets hostname" do
    resp = assert_raises ActionController::RoutingError do
      Rails.application.routes.recognize_path("http://#{ENV.fetch('MLN_SETS_SITE_HOSTNAME', nil)}/help/access-digital-resources")
    end
    assert_equal(true, resp.message.include?(NO_ROUTE_MATCHES))
  end

  private

  def get_info_site_action_params(action_name)
    {:controller => "info_site", :action => action_name, :host => ENV.fetch('MLN_INFO_SITE_HOSTNAME', nil)}
  end
end
