class AddNewSchool < ActiveRecord::Migration[6.1]
  def change
    Rake::Task['ingest:import_all_nyc_schools'].invoke('data/public/Nov_2021_new_school_in_mln.csv', true)
  end
end
