class CleanupSchoolCodes < ActiveRecord::Migration
  def up
    return if School.count == 0 # for Travis

    ActiveRecord::Base.transaction do
      # delete one duplicate school with an extra space in zcode
      s = School.find_by_code("zk681 ")
      if s.users.count == 0
        s.destroy
      else
        raise "Can't delete a school that has users.  Zcode: zk681 "
      end

      # downcase and strip all school codes
      School.all.each do |s|
        puts s.code
        s.code = s.code.downcase.strip
        s.save
      end

      # upload missing schools
      Rake::Task['ingest:import_all_nyc_schools'].invoke('data/public/2016_-_2017_School_Locations.csv')
      Rake::Task['ingest:import_all_nyc_schools'].invoke('data/public/2016_-_2017_School_Locations2.csv')

      # delete schools not found in data.gov
      codes_for_schools_to_delete = [
        "zq496", "zk991", "zx520", "zx295", "zx541", "zx414", "zq494", "zm429", "zx203", "zk596",
        "zm283", "zx690", "zk672", "zm999", "zk487", "zx695", "zk996", "zk998", "zx999", "zk997",
        "zk995", "zx540", "zx239"
      ]
      codes_for_schools_to_delete.each do |code_for_school_to_delete|
        s = School.find_by_code(code_for_school_to_delete)
        s.users.each do |user|
          user.school_id = nil
          user.save
        end
        puts "Deleting school with this code: #{code_for_school_to_delete}."
        s.destroy
      end
    end
  end
end
