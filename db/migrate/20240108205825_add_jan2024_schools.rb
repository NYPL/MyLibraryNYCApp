# frozen_string_literal: true

class AddJan2024Schools < ActiveRecord::Migration[6.1]
  def up
    Rake::Task['ingest:import_all_nyc_schools'].invoke('data/public/January_2024_schools_in_mln.csv', true)
    Rake::Task['ingest_sierra_data:import_sierra_codes_and_zcodes'].invoke('data/public/January_2024_sierra_codes.csv', true)
  end
end
