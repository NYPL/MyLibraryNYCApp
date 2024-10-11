# frozen_string_literal: true

require 'yaml'

# MlnConfigurationController class loads all configurations from "app/config/*.yml" and S3 bucket.
# In future any one will create new configs, we can access all configs from this controller.
class MlnConfigurationController < ApplicationController
  def initialize
    super
    @feature_flag_config = nil
    @elasticsearch_config = nil
    @app_env = ENV['RACK_ENV'].nil? ? 'local' : ENV['RACK_ENV']
    load_all_configs
  end

  # Load feature flag configurations based on environment
  def feature_flag_config(key)
    @feature_flag_config[@app_env][key]
  end

  # Load elastic search configurations based on environment
  def elasticsearch_config(key)
    @elasticsearch_config[@app_env][key]
  end

  private

  # Loading config files for local
  def load_config_for_local
    @feature_flag_config = YAML.load_file('config/feature_flag.yml')
    @elasticsearch_config = YAML.load_file('config/elastic_search.yml')
  end

  def load_config
    # Load feature_flag configurations from s3 bucket.
    @feature_flag_config = YAML.safe_load(S3Controller.new.get_s3_file("my-library-nyc-config-#{ENV.fetch('RAILS_ENV', nil)}",
                                                                       "feature_flag.yml"))    

    # Load elastic search configurations for all environments
    @elasticsearch_config = YAML.load_file('config/elastic_search.yml')
  end

  def load_all_configs
    # Load local configurations
    if ['development', 'test', nil].include?(@app_env)
      load_config_for_local
    else
      # Load dev, qa, prod, test configurations
      load_config
    end
  end
end
