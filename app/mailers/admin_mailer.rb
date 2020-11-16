# frozen_string_literal: true

class AdminMailer < ActionMailer::Base
  include LogWrapper
  LOG_TAG = "AdminMailer"
  default :from => '"MyLibraryNYC Admin" <no-reply@mylibrarynyc.org>'

  # Sends an email to let admins know that a request to create/update a bib(s) failed
  def failed_bibs_controller_api_request(request_body, error_code_and_message, action_name, teacher_set)
    begin
      @teacher_set = teacher_set
      @action_name = action_name
      @request_body = request_body
      @error_code_and_message = error_code_and_message
      emails = AdminUser.where(email_notifications:true).pluck(:email)
      LogWrapper.log('DEBUG', {
        'message' => "About to send failed_bibs_controller_api_request email.\n@error_code_and_message: #{@error_code_and_message || 'nil'}",
        'method' => 'AdminMailer.failed_bibs_controller_api_request'
      })
      mail(:to => emails, :subject => "Problem occurred updating bib from Sierra")
    rescue => exception
      LogWrapper.log('ERROR', {
        'message' => "Cannot send failed_bibs_controller_api_request notification email.  Backtrace=#{exception.backtrace}.",
        'method' => 'AdminMailer.failed_bibs_controller_api_request'
      })
      raise exception
    end
  end

  
  # Sends an email to let admins know that creating/updating a specific bib record failed
  def teacher_set_update_missing_required_fields(bnumber, title, physical_description)
    begin
      @bnumber = bnumber
      @title = title
      @physical_description = physical_description
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

  
  # Sends an email to let admins know that a request to update item availability has failed.
  def failed_items_controller_api_request(error_code_and_message)
    begin
      emails = AdminUser.where(email_notifications:true).pluck(:email)
      LogWrapper.log('DEBUG', {
        'message' => "About to send failed_items_controller_api_request email.\n@error_code_and_message: #{@error_code_and_message || 'nil'}",
        'method' => 'AdminMailer.failed_items_controller_api_request'
      })
      mail(:to => emails, :subject => "Problem occurred updating bib availability")
    rescue => exception
      LogWrapper.log('ERROR', {
        'message' => "Cannot send failed_items_controller_api_request notification email.  Backtrace=#{exception.backtrace}.",
        'method' => 'AdminMailer.failed_items_controller_api_request'
      })
      raise exception
    end
  end


  # Sends confirmation email link to news-letter subscriber.
  def send_news_letter_confirmation_email(encrypt_email, email)
    begin
      @encrypt_email = encrypt_email
      attachments.inline['news-letter-email-logo.png'] = File.read(Rails.root.join("app/assets/images/news-letter-email-logo.png"))
      mail(to: [email], :subject => "MylibraryNYC Newsletter - confirmation requested")
    rescue => exception
      LogWrapper.log('ERROR', {
        'message' => "Cannot send send news letter confirmation email. Error message:#{exception.message},
          backtrace=#{exception.backtrace}.", 'method' => 'AdminMailer.send_news_letter_confirmation_email'
      })
      raise exception.message
    end
  end
end
