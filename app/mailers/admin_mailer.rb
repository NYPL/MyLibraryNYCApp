class AdminMailer < ActionMailer::Base
  include LogWrapper
  LOG_TAG = "AdminMailer"
  default :from => "no-reply@mylibrarynyc.org"

  # Sends an email to let admins know that a request to create/update a bib(s) failed
  def failed_bibs_controller_api_request(request_body, error_code_and_message, action_name)
    begin
      @action_name = action_name
      @request_body = request_body
      @error_code_and_message = error_code_and_message
      emails = AdminUser.where(email_notifications:true).pluck(:email)
      LogWrapper.log('DEBUG', {
        'message' => "About to send failed_bibs_controller_api_request email",
        'method' => 'AdminMailerfailed_bibs_controller_api_request'
      })
      mail(:to => emails, :subject => "Problem occurred updating bib from Sierra")
    rescue => exception
      LogWrapper.log('ERROR', {
        'message' => "Cannot send failed_bibs_controller_api_request notification email.  Backtrace=#{exception.backtrace}.",
        'method' => 'AdminMailer failed_bibs_controller_api_request'
      })
      raise exception
    end
  end

  # Sends an email to let admins know that creating/updating a specific bib record failed
  def teacher_set_update_missing_required_fields(bnumber, title, physical_description, description)
    begin
      @bnumber = bnumber
      @title = title
      @physical_description = physical_description
      @description = description
      emails = AdminUser.where(email_notifications:true).pluck(:email)
      LogWrapper.log('DEBUG', {
        'message' => "About to send failed_bibs_controller_api_request email",
        'method' => 'AdminMailer teacher_set_update_missing_required_fields'
      })
      mail(:to => emails, :subject => "New teacher set bib in Sierra is missing required fields")
    rescue => exception
      LogWrapper.log('ERROR', {
        'message' => "Cannot send failed_bibs_controller_api_request notification email.  Backtrace=#{exception.backtrace}.",
        'method' => 'AdminMailer teacher_set_update_missing_required_fields'
      })
      raise exception
    end
  end
end
