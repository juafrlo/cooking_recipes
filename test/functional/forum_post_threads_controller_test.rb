require 'test_helper'

class ForumPostThreadsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:forum_post_threads)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create forum_post_thread" do
    assert_difference('ForumPostThread.count') do
      post :create, :forum_post_thread => { }
    end

    assert_redirected_to forum_post_thread_path(assigns(:forum_post_thread))
  end

  test "should show forum_post_thread" do
    get :show, :id => forum_post_threads(:one).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => forum_post_threads(:one).id
    assert_response :success
  end

  test "should update forum_post_thread" do
    put :update, :id => forum_post_threads(:one).id, :forum_post_thread => { }
    assert_redirected_to forum_post_thread_path(assigns(:forum_post_thread))
  end

  test "should destroy forum_post_thread" do
    assert_difference('ForumPostThread.count', -1) do
      delete :destroy, :id => forum_post_threads(:one).id
    end

    assert_redirected_to forum_post_threads_path
  end
end
