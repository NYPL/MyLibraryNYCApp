# frozen_string_literal: true

class SchoolsController < ApplicationController
  layout 'info_site/application'
  
  def index
    # Group by first letter of the school.
    @schools = School.active.group_by { |i| i.name[0] }
    @schools_arr = []
    @schools.each do |key, value|
      school_hash = {}
      # If school name is start with alphabet letter, school names will display under aplhabet anchor eg: 'A' Academy for Careers (12), Academy(22).
      # If school name is not start with alphabet letter, school names will display under '#' anchor. eg: '#' 486 newyork school (86),  56test(234).
      school_hash['schoolname_first_letter'] = key.match?(/[A-Za-z]/) ? key : '#'
      school_hash['school_names'] = value.collect do |i|
        code = i.code.present? ? i.code[1..-1].upcase : ""
        "#{i.name} (#{code})"
      end
      @schools_arr << school_hash
    end
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
