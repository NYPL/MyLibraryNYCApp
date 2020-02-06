class UpdateCreatedAtColumnInSchoolDb < ActiveRecord::Migration[5.0]
  def change
    #Updated create_at value if create_at value is null
    School.find_each do |s|
      s.created_at = Time.zone.parse("2000-01-01 1:00:00") if s.created_at.nil?
      s.save!
    end
    # Created_at column should not be null.
    change_column :schools, :created_at, :datetime, null: false
  end
end
