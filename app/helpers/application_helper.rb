# frozen_string_literal: true

module ApplicationHelper
  #Sometimes want to re-write devise error messages.
  #Update devise error messages with custom error messages.
  #Example of resource.errors =  @messages={:alt_email=>["has already been taken"], 
  #:pin=>["does not meet our requirements. Please try again."]}>
  #Example of error_msg_hash = {:alt_email=>["Alternate email has already been taken"], 
  #:pin=>["PIN does not meet our requirements. Please try again."]}
  def custom_devise_error_messages(error_msg_hash={})
    return "" if resource.errors.empty?
    
    messages = resource.errors.messages.merge(error_msg_hash)
    messages = messages.values.flatten!.map { |msg| content_tag(:li, msg) }.join
    sentence = I18n.t("errors.messages.not_saved",
                      count: resource.errors.count,
                      resource: resource.class.model_name.human.downcase)

    html = <<-HTML
    <div id="error_explanation">
      <h2>#{sentence}</h2>
      <ul>#{messages}</ul>
    </div>
    HTML

    html.html_safe
  end

  def info_site_home_page?
    params["host"] == ENV['MLN_INFO_SITE_HOSTNAME'] && params["controller"] == "info_site" && params["action"] == "index"
  end
end
