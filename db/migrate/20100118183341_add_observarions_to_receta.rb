class AddObservarionsToReceta < ActiveRecord::Migration
  def self.up
    add_column :recetas, :observations, :text
  end

  def self.down
    remove_column :recetas, :observations
  end
end
