# frozen_string_literal: true

class SchoolsController < ApplicationController
  layout 'info_site/application'
  
  def index
    # Group by first letter of the school.
    schools = School.active.group_by { |school| school.name[0] }
    @schools_arr = []
    schools.each do |alphabet_anchor, school_objects|
      school_hash = {}
      # If school name starts with alphabet letter, school names will display under aplhabet anchor eg: 'A' Academy for Careers (12), Academy(22).
      # If school name does not start with alphabet letter, school names will display under '#' anchor. eg: '#' 486 newyork school (86),  56test(234).
      school_hash['alphabet_anchor'] = alphabet_anchor.match?(/[A-Za-z]/) ? alphabet_anchor : '#'
      school_hash['school_names'] = school_objects.collect do |school|
        code = school.code.present? ? school.code[1..-1].upcase : ""
        "#{school.name} (#{code})"
      end
      @schools_arr << school_hash
    end
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: schools }
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
