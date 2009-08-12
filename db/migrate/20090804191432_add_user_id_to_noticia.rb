class AddUserIdToNoticia < ActiveRecord::Migration
  def self.up
    add_column :noticias, :user_id, :integer
  end

  def self.down
    remove_column :noticias, :user_id
  end
end
