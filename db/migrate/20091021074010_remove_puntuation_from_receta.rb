class RemovePuntuationFromReceta < ActiveRecord::Migration
  def self.up
    remove_column :recetas, :puntuation
  end

  def self.down
    add_column :recetas, :puntuation, :float
  end
end
