# frozen_string_literal: true

class AddParochialSchoolsOct2018 < ActiveRecord::Migration[4.2]
  def up
    # First create the new schools by adding them to a CSV like this.
    # This task is idempotent.
    # If data is missing or if the value in Location 1 doesn't match a borough,
    # then you will see an error when you run this migration which you can fix in the CSV.
    # The second argument is for whether we want these schools to be active or not.
    Rake::Task['ingest:import_all_nyc_schools'].invoke('data/public/Oct_2018_New_Schools.csv', true)
    # Then add the news school codes at the bottom of this CSV so we can populate the SierraCodeZcodeMatch records.
    # This rake task will destroy and re-create all matches between sierra_codes and zcodes.
    # Consequently, each existing code will get a new primary key but nothing depends on that primary key.
    # Note: zcode letters must be lowercase.
    Rake::Task['ingest:overwrite_sierra_code_zcode_matches'].invoke('data/public/sierra_code_zcode_matches.csv')
  end
end
