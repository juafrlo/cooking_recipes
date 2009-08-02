require 'test_helper'

class ForumRepliesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:forum_replies)
  end

  test "should get new" do
    login_as :aaron
    get :new, :forum_post_id => 1
    assert_response :success
  end

  test "should create forum_reply" do
    login_as :aaron
    assert_difference('ForumReply.count') do
      post :create, 
      :forum_reply => {:reply => 'Some reply'},
      :forum_post_id => 1
    end
    assert_redirected_to forum_post_path(assigns(:forum_reply).forum_post)
  end

  test "should show forum_reply" do
    get :show, :id => forum_replies(:one).id
    assert_response :success
  end

  test "should get edit" do
    login_as :aaron
    get :edit, :id => forum_replies(:one).id
    assert_response :success
  end

  test "other user should not get edit" do
    login_as :old_password_holder
    get :edit, :id => forum_replies(:one).id
    assert_redirected_to '/'
  end


  test "should update forum_reply" do
    login_as :aaron
    put :update,
      :id => forum_replies(:one).id,
      :forum_reply => { },
      :forum_post_id => 1
    assert_redirected_to forum_reply_path(assigns(:forum_reply))
  end

  test "other user should not update forum_reply" do
    login_as :old_password_holder
    put :update,
      :id => forum_replies(:one).id,
      :forum_reply => { },
      :forum_post_id => 1
    assert_redirected_to '/'
  end


  test "should destroy forum_reply" do
    login_as :quentin
    assert_difference('ForumReply.count', -1) do
      delete :destroy, :id => forum_replies(:one).id
    end
    assert_redirected_to forum_post_path(forum_replies(:one).forum_post)
  end
end
