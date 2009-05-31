class AddStatusIdInitiatorToFriendships < ActiveRecord::Migration
  def self.up
    add_column :friendships, :status, :string, :default => "pending"
    add_column :friendships, :initiator, :boolean, :default => false
  end

  def self.down
    remove_column :friendships, :initiator
    remove_column :friendships, :status
  end
end
