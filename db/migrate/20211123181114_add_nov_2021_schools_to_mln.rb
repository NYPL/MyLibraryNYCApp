# frozen_string_literal: true

class AddNov2021SchoolsToMln < ActiveRecord::Migration[6.1]
  def up
    Rake::Task['ingest:import_all_nyc_schools'].invoke('data/public/Nov_2021_new_school_in_mln.csv', true)
  end
end
