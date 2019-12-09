# frozen_string_literal: true

class HomeController < ApplicationController
  layout 'empty', :only => [ :extend_session_iframe ]

  def index
  end


  def help
  end


  def swagger_docs
  	render :json => File.read("app/controllers/api/swagger/swaggerDoc.json")
  end 

  
  # for timing out sessions, this method reloads a hidden iframe so that the user's session["warden.user.user.session"]["last_request_at"] updates
  def extend_session_iframe
    user_signed_in?
  end
end
