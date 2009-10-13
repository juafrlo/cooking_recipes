class AddFriendshipNotificationToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :receive_friendships_emails, :boolean
  end

  def self.down
    remove_column :users, :receive_friendships_emails
  end
end
