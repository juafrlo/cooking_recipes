class FriendshipStatus < ActiveRecord::Base
  has_many :users
end
