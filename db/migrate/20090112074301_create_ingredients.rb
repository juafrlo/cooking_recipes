class CreateIngredients < ActiveRecord::Migration
  def self.up
    create_table :ingredients do |t|
      t.integer :receta_id
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :ingredients
  end
end
