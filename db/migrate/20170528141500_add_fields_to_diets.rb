class AddFieldsToDiets < ActiveRecord::Migration
  def change
    add_column(:diets, :menu, :boolean, { :default => false, :null => false })
    add_column(:diets, :code, :string, { :default => '', :null => false })
    add_column(:diet_versions, :menu, :boolean, { :default => false, :null => false })
    add_column(:diet_versions, :code, :string, { :default => '', :null => false })
  end
end
