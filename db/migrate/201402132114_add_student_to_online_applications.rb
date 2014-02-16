class AddStudentToOnlineApplications < ActiveRecord::Migration
  def change
    add_column :online_applications, :student, :boolean, :default => false
  end
end
