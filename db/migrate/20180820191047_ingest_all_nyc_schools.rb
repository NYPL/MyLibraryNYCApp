class IngestAllNycSchools < ActiveRecord::Migration
  def up
    Rake::Task['ingest:import_all_nyc_schools'].invoke('data/public/2016_-_2017_School_Locations.csv')
  end
end
