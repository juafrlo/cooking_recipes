class AddCountryTownToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :country, :string
    add_column :users, :town, :string
  end

  def self.down
    remove_column :users, :town
    remove_column :users, :country
  end
end
