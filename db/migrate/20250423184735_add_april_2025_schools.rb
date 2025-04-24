class AddApril2025Schools < ActiveRecord::Migration[7.2]
  def up
    Rake::Task["ingest:import_all_nyc_schools"].invoke("data/public/April_2025_update_school_zcodes_in_mln.csv", true)
    Rake::Task["ingest_sierra_data:import_sierra_codes_and_zcodes"].invoke("data/public/April_2025_add_schools.csv", true)
  end
end
