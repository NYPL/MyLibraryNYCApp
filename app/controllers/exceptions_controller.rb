class ExceptionsController < ActionController::Base
  layout 'application'

  def render_error
    @hide_breadcrumbs = true
    @exception = env["action_dispatch.exception"]
    @status_code = ActionDispatch::ExceptionWrapper.new(env, @exception).status_code
  end
end
