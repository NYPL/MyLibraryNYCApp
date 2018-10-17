class Api::V01::GeneralController < ApplicationController
  include LogWrapper

  def unauthorized
    render json: { 'message': 'unauthorized' }, status: 401
  end
end
