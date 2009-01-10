require 'test_helper'

class ThreadsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:threads)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create thread" do
    assert_difference('Thread.count') do
      post :create, :thread => { }
    end

    assert_redirected_to thread_path(assigns(:thread))
  end

  test "should show thread" do
    get :show, :id => threads(:one).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => threads(:one).id
    assert_response :success
  end

  test "should update thread" do
    put :update, :id => threads(:one).id, :thread => { }
    assert_redirected_to thread_path(assigns(:thread))
  end

  test "should destroy thread" do
    assert_difference('Thread.count', -1) do
      delete :destroy, :id => threads(:one).id
    end

    assert_redirected_to threads_path
  end
end
