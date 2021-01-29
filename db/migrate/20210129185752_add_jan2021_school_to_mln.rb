# frozen_string_literal: true

class AddJan2021SchoolToMln < ActiveRecord::Migration[5.0]
  def up
    # First create the new schools by adding them to a CSV like this.
    # This task is idempotent.
    # If data is missing or if the value in Location 1 doesn't match a borough,
    # then you will see an error when you run this migration which you can fix in the CSV.
    # The second argument is for whether we want these schools to be active or not.
    Rake::Task['ingest:import_all_nyc_schools'].invoke('data/public/Jan_2021_missing_school_in_mln.csv', true)
  end
end
