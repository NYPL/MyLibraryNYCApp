# frozen_string_literal: true

def update_create_at_column_in_schools_db
  School.find_each do |s|
    s.created_at = Time.zone.parse("2000-01-01 1:00:00") if s.created_at.nil?
    s.save!
  end
end
update_create_at_column_in_schools_db
