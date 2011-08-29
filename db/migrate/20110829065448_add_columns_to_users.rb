class AddColumnsToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :driver, :boolean
    add_column :users, :rider, :boolean
    add_column :users, :mobile, :string
    add_column :users, :landline, :string

    add_index(:users, :first_name)
    add_index(:users, :last_name)
  end

  def self.down
    remove_column :users, :first_name
    remove_column :users, :last_name
    remove_column :users, :driver
    remove_column :users, :rider
    remove_column :users, :mobile
    remove_column :users, :landline

    remove_index :users, :first_name
    remove_index :users, :last_name
  end
end
