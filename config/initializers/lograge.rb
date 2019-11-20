
MyLibraryNYC::Application.configure do
  config.lograge.enabled = true
  config.lograge.custom_options = lambda do |event|
    {:host => event.payload[:host], :params => event.payload[:params],:level => event.payload[:level]}
  end
  config.lograge.formatter = Lograge::Formatters::Logstash.new
end 