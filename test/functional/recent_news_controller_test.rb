require 'test_helper'

class RecentNewsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:recent_news)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create recent_new" do
    assert_difference('RecentNew.count') do
      post :create, :recent_new => { }
    end

    assert_redirected_to recent_new_path(assigns(:recent_new))
  end

  test "should show recent_new" do
    get :show, :id => recent_news(:one).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => recent_news(:one).id
    assert_response :success
  end

  test "should update recent_new" do
    put :update, :id => recent_news(:one).id, :recent_new => { }
    assert_redirected_to recent_new_path(assigns(:recent_new))
  end

  test "should destroy recent_new" do
    assert_difference('RecentNew.count', -1) do
      delete :destroy, :id => recent_news(:one).id
    end

    assert_redirected_to recent_news_path
  end
end
