# frozen_string_literal: true

#MyLibraryNYC::Application.configure do
#  config.lograge.enabled = true
#  config.lograge.base_controller_class = ['ActionController::API', 'ActionController::Base', 'ActionController::TestCase', 
#                                          'ActionController::ParamsWrapper']
#  config.lograge.custom_options = lambda do |event|
#    {time: Time.now, :host => event.payload[:host], :params => event.payload[:params], :level => event.payload[:level]}
#  end
#  config.lograge.formatter = Lograge::Formatters::Logstash.new
#end
