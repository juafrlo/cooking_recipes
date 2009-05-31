class Friendship < ActiveRecord::Base
  STATUS = ["pending", "accepted", "denied"] 
  validates_presence_of :user_id, :friend_id
  belongs_to :user
end
