class AddRatingToRecetas < ActiveRecord::Migration
  def self.up
    add_column :recetas, :rating, :integer
  end

  def self.down
    remove_column :recetas, :rating
  end
end
