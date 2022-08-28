# frozen_string_literal: true

# Be sure to restart your server when you modify this file.

Rails.application.config.session_store :cookie_store, key: '_mln_session'

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rails generate session_migration")
# MyLibraryNYC::Application.config.session_store :active_record_store


# Rails.application.config.session_store :cookie_store, {
#   :key => '_MyLibraryNYC_session',
#   :domain => :all,
#   :same_site => :none,
#   :secure => :true,
#   :tld_length => 2
# }
