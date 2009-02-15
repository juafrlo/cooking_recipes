class AddLastPostReplyToForumCatL2 < ActiveRecord::Migration
  def self.up
    add_column :forum_cat_l2s, :last_post_id, :int
  end

  def self.down
    remove_column :forum_cat_l2s, :last_post_id
  end
end
