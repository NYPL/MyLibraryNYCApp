# frozen_string_literal: true

class ExceptionsController < ActionController::Base
  layout 'application'

  def render_error
    @hide_breadcrumbs = true
    @exception = request.env["action_dispatch.exception"]
    @status_code = ActionDispatch::ExceptionWrapper.new(request.env['action_dispatch.backtrace_cleaner'], @exception).status_code
  end
end
