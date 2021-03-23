# frozen_string_literal: true

module BibService
  include TeacherSetsHelper

  def validate_input_params(req_body, validate=false)

    bnumber = req_body['id']
    title = req_body['title']
    physical_description = var_field('300', req_body)

    req_body_params = []

    if bnumber.blank?
      req_body_params << { value: bnumber, error_msg: BIB_NUMBER_EMPTY[:msg]}
    end

    if title.blank? && validate
      req_body_params << { value: title, error_msg: TITLE_EMPTY[:msg]}
    end

    if physical_description.blank? && validate
      req_body_params << { value: physical_description, error_msg: PHYSICAL_DESCRIPTION_EMPTY[:msg]}
    end

    if req_body_params.present?
      validate_empty_values(req_body_params)
    end
  end


  def var_field(marcTag, req_body)
    @req_body = req_body
    var_field_data(marcTag)
  end


  # build saved_teacher_sets_json_array for the response body
  def bib_response(ts)
    return nil unless ts.present?
    { id: ts.id, bnumber: ts.bnumber, title: ts.title }
  end

end