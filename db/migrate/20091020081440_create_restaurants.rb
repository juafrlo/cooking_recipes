class CreateRestaurants < ActiveRecord::Migration
  def self.up
    create_table :restaurants do |t|
      t.string :name
      t.string :address
      t.string :country
      t.string :town
      t.text :google_maps_code
      t.text :description
      t.string :specialty
      t.float :creator_rating
      t.integer :avg_price
      t.string :photo_file_name
      t.string :photo_content_type
      t.integer :photo_file_size
      t.datetime :photo_updated_at

      t.timestamps
    end
  end

  def self.down
    drop_table :restaurants
  end
end
