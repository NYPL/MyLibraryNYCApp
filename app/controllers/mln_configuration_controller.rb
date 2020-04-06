class MLNConfigurationController < ApplicationController

	def initialize
		@@feature_flag_config = nil
		@@app_env = ENV['RACK_ENV'].nil? ? 'local' : ENV['RACK_ENV']
		@s3_controller = S3Controller.new
    load_config
	end

	def feature_flag_config(key)
		@@feature_flag_config["#{@@app_env}"][key]
	end

	private

  def load_config
  	@@feature_flag_config = YAML.load(@s3_controller.get_s3_file("my-library-nyc-config", "#{ENV['RAILS_ENV']}/feature_flag.yml"))
  end
end