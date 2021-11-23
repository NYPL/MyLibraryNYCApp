# frozen_string_literal: true

class AddNov2021SchoolsToMln < ActiveRecord::Migration[5.0]
  def up
    Rake::Task['ingest:import_all_nyc_schools'].invoke('data/public/Nov_2021_updating_existing_school_names.csv', true)
    Rake::Task['ingest:import_all_nyc_schools'].invoke('data/public/Nov_2021_new_school_in_mln.csv', true)
  end
end
