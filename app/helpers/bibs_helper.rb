# frozen_string_literal: true

module BibsHelper
  include TeacherSetsHelper
  include MlnResponse
  include MlnHelper

  def validate_input_params(req_body, validate = false)
    bnumber = req_body['id']
    title = req_body['title']
    physical_description = var_field(req_body, '300')

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

    validate_empty_values(req_body_params) if req_body_params.present?
  end


  # build saved_teacher_sets_json_array for the response body
  def bib_response(t_set)
    return nil unless t_set.present?

    { id: t_set.id, bnumber: t_set.bnumber, title: t_set.title }
  end
end
