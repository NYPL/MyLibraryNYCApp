class Nov2024Schools < ActiveRecord::Migration[7.0]
  def up
    Rake::Task['ingest:import_all_nyc_schools'].invoke('data/public/November_2024_schools_in_mln.csv', true)
    Rake::Task['ingest_sierra_data:import_sierra_codes_and_zcodes'].invoke('data/public/November_2024_sierra_codes_in_mln.csv', true)
  end
end
