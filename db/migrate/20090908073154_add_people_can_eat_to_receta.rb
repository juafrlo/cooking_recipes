class AddPeopleCanEatToReceta < ActiveRecord::Migration
  def self.up
    add_column :recetas, :people_can_eat, :integer
  end

  def self.down
    remove_column :recetas, :people_can_eat
  end
end
