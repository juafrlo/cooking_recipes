class AddContryTownToRecetas < ActiveRecord::Migration
  def self.up
    add_column :recetas, :country, :string
    add_column :recetas, :town, :string
  end

  def self.down
    remove_column :recetas, :town
    remove_column :recetas, :country
  end
end
