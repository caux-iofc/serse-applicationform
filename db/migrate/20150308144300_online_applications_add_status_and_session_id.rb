class OnlineApplicationsAddStatusAndSessionId < ActiveRecord::Migration
  def up
    add_column :online_applications, :status, :string
    add_column :online_applications, :session_id, :string
  end

  def down
    remove_column :online_applications, :status
    remove_column :online_applications, :session_id
  end
end
