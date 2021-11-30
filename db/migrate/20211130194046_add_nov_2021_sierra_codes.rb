class AddNov2021SierraCodes < ActiveRecord::Migration[6.1]
  def up
    Rake::Task['ingest:import_sierra_codes_and_zcodes'].invoke('data/public/Nov_2021_new_sierra_codes_in_mln.csv', true)
  end
end
