# frozen_string_literal: true

require 'yaml'

# MlnConfigurationController class loads all configurations from "app/config/*.yml" and S3 bucket.
# In future any one will create new configs, we can access all configs from this controller.
class MlnConfigurationController < ApplicationController
  def initialize
    @feature_flag_config = nil
    @elasticsearch_config = nil
    @app_env = ENV['RACK_ENV'].nil? ? 'local' : ENV['RACK_ENV']
    load_all_configs
  end


  # Load feature flag config file based on environment
  def feature_flag_config(key)
    @feature_flag_config[@app_env][key]
  end

  
  # Load elastic search config file based on environment
  def elasticsearch_config(key)
    @elasticsearch_config[@app_env][key]
  end

  private

  # Loading config files for local
  def load_config_for_local
    @feature_flag_config = YAML.load_file('config/feature_flag.yml')
    @elasticsearch_config = YAML.load_file('config/elasticsearch_config.yml')
  end


  def load_config
    # Loading feature_flag config files from s3 bucket.
    @feature_flag_config = YAML.safe_load(S3Controller.new.get_s3_file("my-library-nyc-config", "#{ENV['RAILS_ENV']}/feature_flag.yml"))
    @elasticsearch_config = YAML.load_file('config/elasticsearch_config.yml')
  end


  def load_all_configs
    if @app_env == 'local' || @app_env.nil?
      load_config_for_local
    else
      load_config
    end
  end
end
