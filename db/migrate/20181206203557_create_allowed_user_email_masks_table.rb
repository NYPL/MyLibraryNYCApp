# frozen_string_literal: true

class CreateAllowedUserEmailMasksTable < ActiveRecord::Migration[4.2]
  # NOTE: This table is a stop-gap measure.
  # Until we move user registration/login to be fully managed outside of MLN,
  # we'd like to restrict new user's email addresses to addresses from the Department of Education
  # (ending in end in @schools.nyc.gov), and addresses from the parochial and charter schools in the program.
  # The model added in this migration will let us manage the allowed email addresses
  # from the MLN Admin interface.
  def up
    create_table "allowed_user_email_masks", :force => true do |t|
      t.string  "email_pattern", :null => false
      t.boolean "active", :default => false
      t.datetime "created_at", :null => false
      t.datetime "updated_at", :null => false
    end
  end

  def down
    drop_table "allowed_user_email_masks"
  end
end
