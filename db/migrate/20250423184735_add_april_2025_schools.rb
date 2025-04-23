class AddApril2025Schools < ActiveRecord::Migration[7.2]
  def up
    Rake::Task["ingest:import_all_nyc_schools"].invoke("data/public/April_2025_update_school_zcodes_in_mln.csv", true)
  end
end
