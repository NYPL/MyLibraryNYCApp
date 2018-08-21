class IngestAllNycSchools < ActiveRecord::Migration
  def up
    # Commenting this out so that we can run it after school codes are downcased in db/migrate/20180821150047_cleanup_school_codes.rb
    # This will take effect on production, but QA will have already run this migration.
    # Rake::Task['ingest:import_all_nyc_schools'].invoke('data/public/2016_-_2017_School_Locations.csv')
  end
end
