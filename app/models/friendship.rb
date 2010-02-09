class Friendship < ActiveRecord::Base
  STATUS = ["pending", "accepted"] 
  validates_presence_of :user_id, :friend_id
  belongs_to :user
  belongs_to :friend, :class_name => "User", :foreign_key => "friend_id"

  
  after_create :send_notification_to_user
  
  def self.accept_friendship(user_id, friend_id)
    friendships = Friendship.find(:all, :conditions =>
      ['(  (user_id = ? AND friend_id = ?) 
        OR
        (user_id = ? AND friend_id = ?)  ) 
        AND status = ?',
      user_id, friend_id,
      friend_id, user_id,
      Friendship::STATUS[0]])
    friendships.each do |friendship|
      friendship.status = Friendship::STATUS[1]
      friendship.save
    end
  end
  
  def self.deny_friendship(user_id, friend_id)
    friendships = Friendship.find(:all, :conditions =>
      ['(  (user_id = ? AND friend_id = ?) 
        OR
        (user_id = ? AND friend_id = ?)  )',
      user_id, friend_id,
      friend_id, user_id])
    friendships.each do |friendship|
      friendship.delete
    end
  end
  
  protected
  def send_notification_to_user
    if self.friend.receive_friendships_emails
      UserMailer.deliver_friendship_notification(self.friend) if self.initiator == true
    end
  end
  
end
