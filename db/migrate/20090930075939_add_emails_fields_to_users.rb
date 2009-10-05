class AddEmailsFieldsToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :receive_comments_emails, :boolean, :default => false
    add_column :users, :receive_friends_emails, :boolean, :default => false
  end

  def self.down
    remove_column :users, :receive_friends_emails
    remove_column :users, :receive_comments_emails
  end
end
