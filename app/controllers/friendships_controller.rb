class FriendshipsController < ApplicationController
  before_filter :login_required
    
  # POST /friends
  # POST /friends.xml
  def create
    @friend = Friendship.new(params[:users])
    @friend.initiator = true
    @link_id = params[:link_id]
    @link_class = params[:link_class]
    if @friend.save
      Friendship.create(:user_id => @friend.friend_id, :friend_id => @friend.user_id)
    end
  end
  
  def accept
    Friendship.accept_friendship(params[:users][:user_id],
     params[:users][:friend_id])
  end
  
  def deny
    Friendship.deny_friendship(params[:users][:user_id],
     params[:users][:friend_id])
  end
  
end
