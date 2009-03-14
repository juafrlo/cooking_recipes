class AddDurationToRecetas < ActiveRecord::Migration
  def self.up
    add_column :recetas, :duration, :integer
  end

  def self.down
    remove_column :recetas, :duration
  end
end
