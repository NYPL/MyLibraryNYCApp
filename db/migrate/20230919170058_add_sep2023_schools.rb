# frozen_string_literal: true

class AddSep2023Schools < ActiveRecord::Migration[6.1]
  def up
    Rake::Task['ingest:import_all_nyc_schools'].invoke('data/public/Sep_2023_schools_in_mln.csv', true)
    Rake::Task['ingest_sierra_data:import_sierra_codes_and_zcodes'].invoke('data/public/Sep_2023_sierra_codes_in_mln.csv', true)
  end
end
