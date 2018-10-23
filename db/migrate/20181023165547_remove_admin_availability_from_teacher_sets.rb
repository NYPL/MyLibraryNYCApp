class RemoveAdminAvailabilityFromTeacherSets < ActiveRecord::Migration
  def change
    remove_column :teacher_sets, :admin_availability
  end
end
