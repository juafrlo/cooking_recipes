class CreateRecetas < ActiveRecord::Migration
  def self.up
    create_table :recetas do |t|
      t.string :name
      t.float :puntuation
      t.text :description
      t.string :photo1
      t.string :photo2
      t.integer :category_id
      t.integer :user_id
      
      t.timestamps
    end
  end

  def self.down
    drop_table :recetas
  end
end
