class CreateForumCatL2s < ActiveRecord::Migration
  def self.up
    create_table :forum_cat_l2s do |t|
      t.integer :forum_cat_l1_id
      t.string :title

      t.timestamps
    end
  end

  def self.down
    drop_table :forum_cat_l2s
  end
end
