class RemoveAuthorAndImgFromNoticia < ActiveRecord::Migration
  def self.up
    remove_column :noticias, :autor
    remove_column :noticias, :img_0
  end

  def self.down
    add_column :noticias, :autor, :string
    add_column :noticias, :img_0, :string
  end
end
