class CreateSteps < ActiveRecord::Migration
  def self.up
    create_table :steps do |t|
      t.integer :receta_id
      t.text :explanation

      t.timestamps
    end
  end

  def self.down
    drop_table :steps
  end
end
