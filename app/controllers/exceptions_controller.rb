# frozen_string_literal: true

class ExceptionsController < ApplicationController
  layout 'application'

  def render_error
    @exception       = request.env['action_dispatch.exception']
    @status_code     = ActionDispatch::ExceptionWrapper.new(request.env, @exception).status_code
  end
end
