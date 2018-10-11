class Api::V1::BibsController < ApplicationController
  include LogWrapper
  before_filter :set_request_body

  # Receive teacher sets from a POST request.
  # All records are inside @request_body.
  # Find or create a teacher set in the MLN db and its associated books.
  def create_or_update_teacher_sets
    error_code_and_message = validate_request
    if error_code_and_message.any?
      render_error(error_code_and_message)
      return
    end

    saved_teacher_sets = []
    @request_body.each do |teacher_set_record|
      teacher_set = TeacherSet.where(bnumber: "b#{teacher_set_record['id']}").first_or_initialize
      teacher_set.update_attributes(
        title: teacher_set_record[:title]
        # TODO: update more teacher_set attributes here once the API contract is complete
      )
      teacher_set.update_included_book_list(teacher_set_record)
      if teacher_set.save
        saved_teacher_sets << teacher_set
      else
        # notify_admin_failed_teacherset(teacher_set)
      end
    end

    render status: 200, json: { teacher_sets: saved_teacher_sets_json_array(saved_teacher_sets) }.to_json
  end

  def delete_teacher_sets
    error_code_and_message = validate_request
    if error_code_and_message.any?
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

  # build saved_teacher_sets_json_array for the response body
  def saved_teacher_sets_json_array(saved_teacher_sets)
    return [] if saved_teacher_sets.empty?
    saved_teacher_sets_json_array = []
    saved_teacher_sets.each do |saved_ts|
      saved_teacher_sets_json_array << { id: saved_ts.id, bnumber: saved_ts.bnumber, title: saved_ts.title }
    end
    saved_teacher_sets_json_array
  end

  # this validates that the request is in the correct format
  def validate_request
    if !@request_body.present?
      return [400, 'request body is missing']
    end
    # the tests send data in as params[:_json] but Postman sends it in as an StringIO object
    @request_body.each do |teacher_set_json|
      if teacher_set_json['id'].blank?
        return [400, "ID is missing in teacher_set_json: #{teacher_set_json}"]
      end
    end
    if action_name == 'create_or_update_teacher_sets'
      # specific methods can go here
    elsif action_name == 'delete_teacher_sets'
      # specific methods can go here
    end
    return []
  end

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

  def set_request_body
    # binding.pry
    # request_body = request.body.read
    @request_body = params[:_json] || JSON.parse(request_body)
  end
end
