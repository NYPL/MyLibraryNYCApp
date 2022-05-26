# frozen_string_literal: true

class ExceptionsController < ActionController::Base
  layout 'application'

  def render_error
    @hide_breadcrumbs = true
    @exception = request.env["action_dispatch.exception"]
    puts "###########      #{ActionDispatch::ExceptionWrapper.new(request.env, @exception).status_code}.    #########"
    @status_code = ActionDispatch::ExceptionWrapper.new(request.env, @exception).status_code
  end
end
