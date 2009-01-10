require 'test_helper'

class ForumRepliesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:forum_replies)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create forum_reply" do
    assert_difference('ForumReply.count') do
      post :create, :forum_reply => { }
    end

    assert_redirected_to forum_reply_path(assigns(:forum_reply))
  end

  test "should show forum_reply" do
    get :show, :id => forum_replies(:one).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => forum_replies(:one).id
    assert_response :success
  end

  test "should update forum_reply" do
    put :update, :id => forum_replies(:one).id, :forum_reply => { }
    assert_redirected_to forum_reply_path(assigns(:forum_reply))
  end

  test "should destroy forum_reply" do
    assert_difference('ForumReply.count', -1) do
      delete :destroy, :id => forum_replies(:one).id
    end

    assert_redirected_to forum_replies_path
  end
end
