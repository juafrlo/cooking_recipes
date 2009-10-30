class AddRestaurantsAvgToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :restaurants_avg, :float
  end

  def self.down
    remove_column :users, :restaurants_avg
  end
end
