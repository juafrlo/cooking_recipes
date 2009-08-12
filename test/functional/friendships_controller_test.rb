require 'test_helper'

class FriendshipsControllerTest < ActionController::TestCase
  
  def setup
    login_as :aaron
  end
  
  test "should create friendship" do
    assert_difference('Friendship.count', 2) do
      post :create,
       :users => {:user_id => 1, :friend_id => 2 },
       :link_id => 'some_id'
    end
    assert_response :success
  end
  
  test "should accept friendship" do
    get :accept,
     :users => {:user_id => friendships(:one).user_id,
       :friend_id => friendships(:one).friend_id}
    assert_response :success
  end
  
  test "should deny friendship" do 
    assert_difference('Friendship.count', -1) do
      get :deny,
       :users => {:user_id => friendships(:one).user_id,
         :friend_id => friendships(:one).friend_id }
      assert_response :success
    end
  end

end
