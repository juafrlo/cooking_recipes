class CreateForumCatL1s < ActiveRecord::Migration
  def self.up
    create_table :forum_cat_l1s do |t|
      t.string :title

      t.timestamps
    end
  end

  def self.down
    drop_table :forum_cat_l1s
  end
end
