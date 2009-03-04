class AddDescriptionToForumCatL2 < ActiveRecord::Migration
  def self.up
    add_column :forum_cat_l2s, :description, :text
  end

  def self.down
    remove_column :forum_cat_l2s, :description
  end
end
