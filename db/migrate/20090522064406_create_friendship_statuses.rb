class CreateFriendshipStatuses < ActiveRecord::Migration
  def self.up
    create_table :friendship_statuses do |t|
      t.string :name
      t.timestamps
    end
    FriendshipStatus.create(:name => 'pending')
    FriendshipStatus.create(:name => 'accepted')
    FriendshipStatus.create(:name => 'denied')        
  end

  def self.down
    drop_table :friendship_statuses
  end
end
