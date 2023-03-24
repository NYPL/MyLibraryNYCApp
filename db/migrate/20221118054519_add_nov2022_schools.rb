# frozen_string_literal: true

class AddNov2022Schools < ActiveRecord::Migration[6.1]
  def up
    Rake::Task['ingest:import_all_nyc_schools'].invoke('data/public/Nov_2022_schools_in_mln.csv', true)
    Rake::Task['ingest_sierra_data:import_sierra_codes_and_zcodes'].invoke('data/public/Nov_2022_sierra_codes_in_mln.csv', true)
  end
end
