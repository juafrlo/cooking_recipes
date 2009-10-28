class RemoveSpecialtyFromRestaurants < ActiveRecord::Migration
  def self.up
    remove_column :restaurants, :specialty
  end

  def self.down
    add_column :specialty, :specialty
  end
end
