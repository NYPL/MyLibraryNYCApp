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

  def adobe_titles
    originating_location = request.fullpath
    site_section = ""
    page_title = ""

    if originating_location.present?
      if originating_location == "/signin"
        site_section = 'Account'
        page_title = 'sign-in'
      elsif originating_location == "/signup"
        site_section = 'Account'
        page_title = 'sign-up'
      elsif originating_location ==  "/account_details"
        site_section = 'Account'
        page_title = 'account-details'
      elsif params["controller"] == "teacher_sets" && params["action"] == "show" && params["id"].present?
        site_section = 'Teacher Sets'
        page_title = 'teacher-set-details'
      elsif originating_location == "/schools"
        page_title = "participating-schools"
        site_section = 'Marketing'
      elsif originating_location == "/faqs/show"
        page_title = "frequently-asked-questions"
        site_section = 'Marketing'
      elsif originating_location == "/contacts"
        page_title = "contact"
        site_section = 'Marketing'
      elsif params["controller"] == "books" && params["action"] == "show" && params["id"].present?
        site_section = 'Teacher Sets'
        page_title = 'book-details'
      elsif params["controller"] == "teacher_sets" && params["action"] == "index"
        site_section = 'Teacher Sets'
        page_title = 'search-teacher-sets'
      elsif params["controller"] == "holds" && params["action"] == "ordered_holds_details" && params["cache_key"].present?
        site_section = 'Order'  
        page_title = 'order-details'
      elsif params["controller"] == "holds" && params["action"] == "holds_cancel_details" && params["cache_key"].present?
        site_section = 'Order'  
        page_title = 'cancel-order'
      elsif originating_location == "/holds/#{params["cache_key"]}"
        site_section = 'Order'  
        page_title = 'order-cancelled'
      else
        site_section = 'Teacher Sets'
        page_title = 'search-teacher-sets'
      end
    end
    page_title_string = 'mylibrarynyc'
    page_title_string += '|' + page_title
    [page_title_string, site_section]
  end
end
