class AddStateToHookup < ActiveRecord::Migration
  def self.up
     add_column :hook_ups, :state, :string
  end

  def self.down
    remove_column :hook_ups, :state
  end
end
  