class UpdateTeacherSetAvailableCopies < ActiveRecord::Migration[5.0]
  def change
    ts_arr = []
    TeacherSet.find_each do |ts|
      next unless ts.ts_holds_count.present?
      if ts.total_copies > 0 && ts.total_copies.present?
        ts.available_copies = ts.total_copies - ts.ts_holds_count.to_i
        if ts.available_copies < 0
          binding.pry
          ts_arr << ts.id
          next
        end
        ts.save!
      end
      puts ">>>>>>>>>>>>>>>.  #{ts_arr} .<<<<<<<<<<<<<<<<<<<"
    end
  end
end
