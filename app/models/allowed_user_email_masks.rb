class AllowedUserEmailMasks < ActiveRecord::Base
  # Setup accessible (or protected) attributes for your model
  attr_accessible :email_pattern, :active, :created_at, :updated_at

end
