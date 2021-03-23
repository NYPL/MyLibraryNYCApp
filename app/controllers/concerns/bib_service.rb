# frozen_string_literal: true

module BibService
  include LogWrapper
  include MlnException
  include MlnResponse
  include TeacherSetConcern

  
  # Create or update teacher-set data

  def create_or_update_teacher_set_data(req_body)
    TeacherSet.new.create_or_update_teacher_set_data(req_body)
  end


  def delete_teacher_set(bib_id)    
    TeacherSet.new.delete_teacher_set(bib_id)
  end


  def validate_input_params(bnumber, title=nil, physical_description=nil, validate=false)
    # validate each teacher_set_record

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
      # Need to talk about sending email.
      # AdminMailer.teacher_set_update_missing_required_fields(bnumber, title, physical_description).deliver
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