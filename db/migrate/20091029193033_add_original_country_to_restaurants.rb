class AddOriginalCountryToRestaurants < ActiveRecord::Migration
  def self.up
    add_column :restaurants, :original_country, :string
  end

  def self.down
    remove_column :restaurants, :original_country
  end
end
