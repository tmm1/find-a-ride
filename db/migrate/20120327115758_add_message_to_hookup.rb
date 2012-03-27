class AddMessageToHookup < ActiveRecord::Migration
  def self.up
    add_column :hook_ups, :message, :string, :limit => 3000
  end

  def self.down
    remove_column :hook_ups, :message
  end
end
