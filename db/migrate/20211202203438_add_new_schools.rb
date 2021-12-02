class AddNewSchools < ActiveRecord::Migration[6.1]
  def change
    Rake::Task['ingest:import_all_nyc_schools'].invoke('data/public/Nov_2021_new_school_in_mln.csv', true)
    Rake::Task['ingest_sierra_data:import_sierra_codes_and_zcodes'].invoke('data/public/Nov_2021_new_sierra_codes_in_mln.csv', true)
  end
end
