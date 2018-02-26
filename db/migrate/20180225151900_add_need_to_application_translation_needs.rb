class AddNeedToApplicationTranslationNeeds < ActiveRecord::Migration
  def change
    add_column(:application_translation_needs, :need, :boolean, { :default => false, :null => false })
    add_column(:application_translation_need_versions, :need, :boolean, { :default => false, :null => false })
  end
end
