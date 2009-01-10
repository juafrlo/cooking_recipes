class CreateForumReplies < ActiveRecord::Migration
  def self.up
    create_table :forum_replies do |t|
      t.integer :forum_post_id
      t.integer :user_id
      t.text :reply

      t.timestamps
    end
  end

  def self.down
    drop_table :forum_replies
  end
end
