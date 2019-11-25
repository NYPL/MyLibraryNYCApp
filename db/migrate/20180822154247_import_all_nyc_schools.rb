# frozen_string_literal: true

class ImportAllNycSchools < ActiveRecord::Migration
  def up
    return if School.count == 0 # for Travis

    ActiveRecord::Base.transaction do
      # upload missing schools
      Rake::Task['ingest:import_all_nyc_schools'].invoke('data/public/2016_-_2017_School_Locations.csv')
      Rake::Task['ingest:import_all_nyc_schools'].invoke('data/public/2016_-_2017_School_Locations2.csv')
    end
  end
end
