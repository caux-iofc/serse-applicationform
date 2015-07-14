class AddUniqueConstraintToOnlineApplicationConferences < ActiveRecord::Migration
  def change
    add_index :online_application_conferences, [:conference_id, :online_application_id], :unique => true, :name => 'index_oa_conf_uniq'
  end
end
