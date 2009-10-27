class CreateRestCategories < ActiveRecord::Migration
  def self.up
    create_table :rest_categories do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :rest_categories
  end
end
