# frozen_string_literal: true

## A "mask" is a regular expression that can be used to isolate/approve a string.
# We're using just the simplest form of a mask, like: "@nypl.org is allowed now".
# We're allowing the admin users to add email address masks (domains is another word that's not
# perfectly accurate) in the form of "@nypl.org", "@schools.nyc.gov", etc., with the "@" sign included.
# (We're hoping that including the "@" will help the Admin Users understand what is an email domain more clearly.)
#
# The email masks stored in this table will be used to restrict the email addresses that site
# users (teachers) can sign up for MLN accounts with.
class AllowedUserEmailMasks < ActiveRecord::Base
  # Setup accessible (or protected) attributes for your model
  # attr_accessible :email_pattern, :active, :created_at, :updated_at

  before_create :normalize_email_strings
  before_update :normalize_email_strings

  def normalize_email_strings
    self.email_pattern = self.email_pattern.downcase.strip
  end
end
