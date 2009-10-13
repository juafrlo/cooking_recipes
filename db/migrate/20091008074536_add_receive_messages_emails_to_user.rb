class AddReceiveMessagesEmailsToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :receive_messages_emails, :boolean
  end

  def self.down
    remove_column :users, :receive_messages_emails
  end
end
