class SchoolsController < ApplicationController
  def index
    @schools = School.active

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @schools }
    end
  end


  def create
    School.create(school_params)
  end

  private

  # Strong parameters: protect object creation and allow mass assignment.
  def school_params
    params.permit(:name, :code, :active, :address_line_1, :address_line_2, :state, :postal_code, :phone_number, :borough)
  end
end
