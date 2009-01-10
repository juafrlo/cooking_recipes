class CreateForumPosts < ActiveRecord::Migration
  def self.up
    create_table :forum_posts do |t|
      t.integer :forum_cat_l2_id
      t.integer :user_id
      t.string :title
      t.text :comment

      t.timestamps
    end
  end

  def self.down
    drop_table :forum_posts
  end
end
