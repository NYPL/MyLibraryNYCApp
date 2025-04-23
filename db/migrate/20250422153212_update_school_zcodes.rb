class UpdateSchoolZcodes < ActiveRecord::Migration[7.2]
  def up
    Rake::Task["ingest_sierra_data:update_sierra_zcodes"].invoke("data/public/April_2025_update_school_zcodes.csv", true)
  end
end
