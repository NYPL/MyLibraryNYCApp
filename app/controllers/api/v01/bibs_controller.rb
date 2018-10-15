class Api::V01::BibsController < ApplicationController
  include LogWrapper
  before_filter :set_request_body

  # Receive teacher sets from a POST request.
  # All records are inside @request_body.
  # Find or create a teacher set in the MLN db and its associated books.
  def create_or_update_teacher_sets
    error_code_and_message = validate_request
    if error_code_and_message.any?
      AdminMailer.failed_bibs_controller_api_request(@request_body, error_code_and_message, action_name)
      render_error(error_code_and_message)
    end
    return if error_code_and_message.any?

    saved_teacher_sets = []
    @request_body.each do |teacher_set_record|
      # overwrite @teacher_set_record instance variable so it can be read in the var_field and fixed_field methods
      @teacher_set_record = teacher_set_record

      # validate each teacher_set_record
      bnumber = teacher_set_record['id']
      title = teacher_set_record['title']
      physical_description = var_field('300')
      description = var_field('520')
      if bnumber.blank? || title.blank? || physical_description.blank? || description.blank?
        AdminMailer.teacher_set_update_missing_required_fields(bnumber, title, physical_description, description)
        next
      end

      teacher_set = TeacherSet.where(bnumber: "b#{bnumber}").first_or_initialize
      teacher_set.update_attributes(
        title: title,
        call_number: var_field('091'),
        description: description,
        edition: var_field('250'),
        isbn: var_field('020'),
        primary_language: fixed_field('24'),
        publisher: var_field('260'),
        contents: var_field('505'),
        primary_subject: var_field('690', false),
        physical_description: physical_description,
        details_url: "http://catalog.nypl.org/record=b#{teacher_set_record['id']}~S1",
        grade_begin: grades(var_field('521'))[0],
        grade_end: grades(var_field('521'))[1],
        # lexile_begin: lexiles(var_field('521'))[0], # TODO: both grades and lexiles are in 521; research how to know which is which.  See b20798106 which hashas both.
        # lexile_end: lexiles(var_field('521'))[1],
        availability: 'available',
        available_copies: 999
      )
      teacher_set.update_subjects_via_api(all_var_fields('650', 'a'))
      teacher_set.update_notes(var_field('500', true))
      teacher_set.update_included_book_list(teacher_set_record)
      saved_teacher_sets << teacher_set
    end

    render status: 200, json: { teacher_sets: saved_teacher_sets_json_array(saved_teacher_sets) }.to_json
  end

  def delete_teacher_sets
    error_code_and_message = validate_request
    if error_code_and_message.any?
      AdminMailer.failed_bibs_controller_api_request(@request_body, error_code_and_message, action_name)
      render_error(error_code_and_message)
      return
    end

    saved_teacher_sets = []
    @request_body.each do |teacher_set_record|
      teacher_set = TeacherSet.where(bnumber: "b#{teacher_set_record['id']}").first
      if teacher_set
        saved_teacher_sets << teacher_set
        teacher_set.destroy
      end
    end

    render status: 200, json: { teacher_sets: saved_teacher_sets_json_array(saved_teacher_sets) }.to_json
  end

  private

  def var_field(marcTag, merge = true)
    begin
      if merge == true
        @teacher_set_record['varFields'].detect{ |hash| hash['marcTag'] == marcTag }['subfields'].map{ |x| x['content']}.join(', ')
      else
        @teacher_set_record['varFields'].detect{ |hash| hash['marcTag'] == marcTag }['subfields'].detect{ |hash| hash['tag'] == 'a' }['content']
      end
    rescue
      return nil
    end
  end

  def all_var_fields(marcTag, tag)
    begin
      @teacher_set_record['varFields'].select{ |hash| hash['marcTag'] == marcTag }.map{|x| x['subfields'][0]['content']}
    rescue
      return nil
    end
  end

  def fixed_field(marcTag)
    begin
      @teacher_set_record['fixedFields'][marcTag]['display']
    rescue
      return nil
    end
  end

  # build saved_teacher_sets_json_array for the response body
  def saved_teacher_sets_json_array(saved_teacher_sets)
    return [] if saved_teacher_sets.empty?
    saved_teacher_sets_json_array = []
    saved_teacher_sets.each do |saved_ts|
      saved_teacher_sets_json_array << { id: saved_ts.id, bnumber: saved_ts.bnumber, title: saved_ts.title }
    end
    saved_teacher_sets_json_array
  end

  # set the @request_body instance variable so it can be used in other methods; check for parsing errors.
  def set_request_body
    begin
      @request_body = params[:_json] || JSON.parse(request.body.read)
    rescue => e
      @parsing_error = e
    end
  end

  # this validates that the request is in the correct format
  def validate_request
    if @parsing_error
      return [400, "Parsing error: #{@parsing_error}"]
    elsif !@request_body || @request_body.empty?
      return [400, "Request body is empty."]
    end
    return []
  end

  # log the error and render it back to the lambda
  def render_error(error_code_and_message)
    LogWrapper.log('ERROR', {
      'message' => error_code_and_message[1],
      'method' => "#{controller_name}##{action_name}",
      'status' => error_code_and_message[0]
    })
    render status: error_code_and_message[0], json: {
      message: error_code_and_message[1]
    }.to_json
  end

  # turn grades into arrays
  def grades(string)
    if string.blank?
      return ''
    else
      return string.gsub('.', '').split('-')
    end
  end

  # turn lexiles into arrays
  # commented out until we have more investigation of lexiles
  # def lexiles(string)
  #   if string.blank?
  #     return ''
  #   else
  #     return string.gsub('Lexile ', '').gsub('L', '').split(' ')[0].split('-')
  #   end
  # end
end
