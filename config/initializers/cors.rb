Rails.application.config.action_controller.forgery_protection_origin_check = false

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins '*'
    resource '*',
      headers: :any,
      methods: [:get, :post, :put, :patch, :delete, :options, :head, :destroy],
      credentials: false
    end
end