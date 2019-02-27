class Api::V01::BibsController < ApplicationController
  include LogWrapper

  before_filter :set_request_body
  before_filter :validate_source_of_request

  # Receive teacher sets from a POST request.
  # All records are inside @request_body.
  # Find or create a teacher set in the MLN db and its associated books.
  def create_or_update_teacher_sets
    LogWrapper.log('DEBUG', {'message' => 'create_or_update_teacher_sets.start','method' => 'bibs_controller.create_or_update_teacher_sets'})

    error_code_and_message = validate_request
    if error_code_and_message.any?
      AdminMailer.failed_bibs_controller_api_request(@request_body, error_code_and_message, action_name, nil).deliver
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

      if bnumber.blank? || title.blank? || physical_description.blank?
        AdminMailer.teacher_set_update_missing_required_fields(bnumber, title, physical_description).deliver
        next
      end

      teacher_set = TeacherSet.where(bnumber: "b#{bnumber}").first_or_initialize

      # make the teacher set available if it is newly created (.persisted? means that it's saved in the db):
      # TODO: In the future, availability information will come through in its own stream, and hard-coding
      # availability rules into the code will need to go away.  Labeling this code line as potential tech debt.
      teacher_set.update_attributes(availability: 'available') if !teacher_set.persisted?
      begin
        teacher_set.update_attributes(
          title: title,
          call_number: var_field('091'),
          description: var_field('520'),
          edition: var_field('250'),
          isbn: var_field('020'),
          primary_language: fixed_field('24'),
          publisher: var_field('260'),
          contents: var_field('505'),
          primary_subject: var_field('690', false),
          physical_description: physical_description,
          details_url: "http://catalog.nypl.org/record=b#{teacher_set_record['id']}~S1",
          grade_begin: grade_or_lexile_array('grade')[0] || '',
          grade_end: grade_or_lexile_array('grade')[1] || '',
          lexile_begin: grade_or_lexile_array('lexile')[0] || '',
          lexile_end: grade_or_lexile_array('lexile')[1] || '',
          available_copies: 999
        )
      rescue => exception
        log_error('create_or_update_teacher_sets', exception)
        AdminMailer.failed_bibs_controller_api_request(@request_body, "One attribute may be too long.  Error: #{exception.message[0..200]}...", action_name, teacher_set).deliver
      end
      begin
        # clean up the primary subject field to match the subject field string rules
        teacher_set.clean_primary_subject()
      rescue => exception
        log_error('clean_primary_subject', exception)
        AdminMailer.failed_bibs_controller_api_request(@request_body, "Error updating primary subject via API: #{exception.message[0..200]}...", action_name, teacher_set).deliver
      end
      begin
        teacher_set.update_subjects_via_api(all_var_fields('650', 'a'))
      rescue => exception
        log_error('create_or_update_teacher_sets', exception)
        AdminMailer.failed_bibs_controller_api_request(@request_body, "Error updating subjects via API: #{exception.message[0..200]}...", action_name, teacher_set).deliver
      end
      begin
        teacher_set.update_notes(var_field('500', true))
      rescue => exception
        log_error('create_or_update_teacher_sets', exception)
        AdminMailer.failed_bibs_controller_api_request(@request_body, "Error updating notes via API: #{exception.message[0..200]}...", action_name, teacher_set).deliver
      end
      begin
        teacher_set.update_included_book_list(teacher_set_record)
      rescue => exception
        log_error('create_or_update_teacher_sets', exception)
        AdminMailer.failed_bibs_controller_api_request(@request_body, "Error updating the associated book records via API: #{exception.message[0..200]}...", action_name, teacher_set).deliver
      end

      saved_teacher_sets << teacher_set
      LogWrapper.log('DEBUG', {'message' => 'create_or_update_teacher_sets:finished making teacher set','method' => 'bibs_controller.create_or_update_teacher_sets'})
    end

    render status: 200, json: { teacher_sets: saved_teacher_sets_json_array(saved_teacher_sets) }.to_json
  end

  def delete_teacher_sets
    error_code_and_message = validate_request
    if error_code_and_message.any?
      AdminMailer.failed_bibs_controller_api_request(@request_body, error_code_and_message, action_name, nil).deliver
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

    # Requests to the MLN teacher set-updating api must come from our verified lambdas,
    # unless are being tested or developed.
    def validate_source_of_request
      LogWrapper.log('DEBUG',
        {
         'message' => 'Request sent to BibsController#validate_source_of_request',
         'method' => 'validate_source_of_request',
         'status' => 'start',
         'dataSent' => "request.headers['X-API-Key']:#{request.headers['X-API-Key']}"
        })

      redirect_to '/api/unauthorized' unless Rails.env.test? || Rails.env.local? || request.headers['X-API-Key'] == ENV['API_GATEWAY_HEADER_KEY']
    end

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


    # Prepare and write an error message to the application log.
    def log_error(method, exception)
      if method.blank?
        method = "#{controller_name or 'unknown_controller'}##{action_name or 'unknown_action'}"
      end

      message = (exception && exception.message ? exception.message[0..200] : 'exception or exception message missing')
      backtrace = (exception ? exception.backtrace : 'exception missing')
      LogWrapper.log('ERROR', {
        'message' => "#{message}...\nBacktrace=#{backtrace}.",
        'method' => method
      })
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


    def grade_or_lexile_array(return_grade_or_lexile)
      grade_and_lexile_json = all_var_fields('521', 'content')
      return '' if grade_and_lexile_json.blank?

      grade_and_lexile_json.each do |grade_or_lexile_json|
        begin
          if return_grade_or_lexile == 'lexile' && grade_or_lexile_json.include?('L')
            return grade_or_lexile_json.gsub('Lexile ', '').gsub('L', '').split(' ')[0].split('-')
          elsif return_grade_or_lexile == 'grade' && !grade_or_lexile_json.include?('L')
            return grade_or_lexile_json.gsub('.', '').split('-')
          end
        rescue
          []
        end
      end
    end

  # end private methods
end
