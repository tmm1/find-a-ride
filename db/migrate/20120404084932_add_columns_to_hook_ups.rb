class AddColumnsToHookUps < ActiveRecord::Migration
  def self.up
    add_column :hook_ups, :hookable_id, :integer
    add_column :hook_ups, :hookable_type, :string
  end

  def self.down
    remove_column :hook_ups, :hookable_id
    remove_column :hook_ups, :hookable_type
  end
end
