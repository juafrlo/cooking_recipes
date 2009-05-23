class AddFriendshipStatusIdInitiatorToFriends < ActiveRecord::Migration
  def self.up
    add_column :friends, :friendship_status_id, :integer, :default => 1
    add_column :friends, :initiator, :boolean, :default => false
  end

  def self.down
    remove_column :friends, :initiator
    remove_column :friends, :friendship_status_id
  end
end
