class AddAdminAvailabilityToTeacherSets < ActiveRecord::Migration
  def change
    add_column :teacher_sets, :admin_availability
  end
end
