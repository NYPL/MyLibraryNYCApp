# frozen_string_literal: true

class UpdateTeacherSetAvailableCopies < ActiveRecord::Migration[5.0]
  def change
    # Uncomment if it is required in future.
    # ts_arr = []
    # TeacherSet.find_each do |ts|
    #   # Get all teacher-set status holds except for cancelled and closed.
    #   next unless ts.ts_holds_count.present?

    #   # Total copies should be present and it should be more than zero.
    #   if ts.total_copies.positive? && ts.total_copies.present?
    #     ts.available_copies = ts.total_copies - ts.ts_holds_count.to_i
    #     if ts.available_copies.negative?
    #       ts_arr << ts.id
    #       next
    #     end
    #     ts.save!
    #   end
    #   puts ">>>>>>>>>>>>>>>.  #{ts_arr} .<<<<<<<<<<<<<<<<<<<"
    # end
  end
end
