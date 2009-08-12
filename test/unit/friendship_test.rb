require 'test_helper'

class FriendshipTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
  
  test "accept_friendship" do 
    Friendship.accept_friendship(friendships(:one).user_id,friendships(:one).friend_id)
    assert_equal Friendship.find(1).status, "accepted"
    Friendship.accept_friendship(friendships(:two).user_id,friendships(:two).friend_id)
    assert_equal Friendship.find(1).status, "accepted"    
  end

  test "deny_friendship" do 
    assert_difference('Friendship.count', -1) do
      Friendship.deny_friendship(friendships(:one).user_id,friendships(:one).friend_id)
    end
    assert_difference('Friendship.count', -1) do
      Friendship.deny_friendship(friendships(:two).user_id,friendships(:two).friend_id)
    end

  end

end
