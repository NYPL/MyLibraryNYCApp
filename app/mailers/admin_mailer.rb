class AdminMailer < ActionMailer::Base
  LOG_TAG = "AdminMailer"
  default :from => "no-reply@mylibrarynyc.org"

  # Sends an email to let admins know that a request to create/update a bib(s) failed
  def failed_bibs_controller_api_request(request_body, error_code_and_message, method_name)
    begin
      @action_name = action_name
      @request_body = request_body
      @error_code_and_message = error_code_and_message
      emails = AdminUser.pluck(:email)
      Rails.logger.debug("#{LOG_TAG}.admin_notification: About to send failed_bibs_controller_api_request email")
      mail(:to => emails, :subject => "New failed_bibs_controller_api_request")
    rescue => exception
      Rails.logger.error("#{LOG_TAG}.admin_notification: Cannot send failed_bibs_controller_api_request notification email.  Backtrace=#{exception.backtrace}.")
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
      emails = AdminUser.pluck(:email)
      Rails.logger.debug("#{LOG_TAG}.admin_notification: About to send failed_bibs_controller_api_request email")
      mail(:to => emails, :subject => "New failed_bibs_controller_api_request")
    rescue => exception
      Rails.logger.error("#{LOG_TAG}.admin_notification: Cannot send failed_bibs_controller_api_request notification email.  Backtrace=#{exception.backtrace}.")
      raise exception
    end
  end
end
