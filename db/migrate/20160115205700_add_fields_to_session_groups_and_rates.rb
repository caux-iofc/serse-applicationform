class AddFieldsToSessionGroupsAndRates < ActiveRecord::Migration
  def change
    add_column(:session_groups, :early_bird_register_by, :datetime)
    add_column(:conferences, :early_bird_discount_percentage, :integer, { :default => 0, :null => false })
    add_column(:rates, :early_bird_discount_eligible, :boolean, { :default => false, :null => false })
  end
end
