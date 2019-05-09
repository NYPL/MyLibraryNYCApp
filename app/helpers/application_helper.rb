module ApplicationHelper
	def custom_devise_error_messages(error_msg_hash={})
    return "" if resource.errors.empty?

    messages = resource.errors.messages.update(error_msg_hash)
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
end
