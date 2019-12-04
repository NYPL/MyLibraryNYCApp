# frozen_string_literal: true

ActiveAdmin.register AllowedUserEmailMasks do
  menu priority: 100

  menu label: "Allowed Emails"
  index title: "Allowed Emails"

  # Setting up Strong Parameters
  # You must specify permitted_params within your AllowedUserEmailMasks ActiveAdmin resource which reflects a allowed_user_email_masks's expected params.
  controller do
    def permitted_params
      params.permit allowed_user_email_masks: [:email_pattern, :active, :created_at, :updated_at]
    end
  end
end
