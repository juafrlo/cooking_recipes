class CreateNoticias < ActiveRecord::Migration
  def self.up
    create_table :noticias do |t|
      t.string :title
      t.string :subtitle
      t.string :autor
      t.string :img_0
      t.text :intro
      t.text :content
      t.date :date
      t.timestamps
    end
  end

  def self.down
    drop_table :noticias
  end
end
