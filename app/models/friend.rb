class Friend < ActiveRecord::Base
  validates_presence_of :user_id, :friend_id
  belongs_to :user
end
