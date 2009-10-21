class RemoveRatingFieldFromRecetas < ActiveRecord::Migration
  def self.up
    remove_column :recetas, :rating
  end

  def self.down
    add_column :recetas, :rating, :integer
  end
end
