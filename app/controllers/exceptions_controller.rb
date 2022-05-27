# frozen_string_literal: true

class ExceptionsController < ActionController::Base
  layout 'application'

  def render_error
    @exception = request.env["action_dispatch.exception"]
    exception_wrapper = ActionDispatch::ExceptionWrapper.new(request.env['action_dispatch.backtrace_cleaner'], @exception)
    trace = exception_wrapper.application_trace
  end
end
