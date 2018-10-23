class AddAdminAvailabilityToTeacherSets < ActiveRecord::Migration
  def change
    add_column :teacher_sets, :admin_availability, :boolean, default: true
  end
end
