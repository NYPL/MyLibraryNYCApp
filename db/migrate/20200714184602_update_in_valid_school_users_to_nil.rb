# frozen_string_literal: true

class UpdateInValidSchoolUsersToNil < ActiveRecord::Migration[5.0]
  def change
    User.where('school_id NOT IN (SELECT id FROM schools)').each do |user|
      user.school_id = nil
      user.save!
    end
  end
end
