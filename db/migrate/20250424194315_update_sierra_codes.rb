class UpdateSierraCodes < ActiveRecord::Migration[7.2]
  def up
    Rake::Task["ingest_sierra_data:import_sierra_codes_and_zcodes"].invoke("data/public/sierra_code_zcode_matches.csv", true)
  end
end
