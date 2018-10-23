class Api::V01::GeneralController < ApplicationController
  include LogWrapper

  def unauthorized
    render json: { 'message': 'Unauthorized message from MLN Api::V01::GeneralController' }, status: 401
  end
end
