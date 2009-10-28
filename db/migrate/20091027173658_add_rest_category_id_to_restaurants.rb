class AddRestCategoryIdToRestaurants < ActiveRecord::Migration
  def self.up
    add_column :restaurants, :rest_category_id, :integer
  end

  def self.down
    remove_column :restaurants, :rest_category_id
  end
end
