require 'test_helper'

class ForumCatL2sControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:forum_cat_l2s)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create forum_cat_l2" do
    assert_difference('ForumCatL2.count') do
      post :create, :forum_cat_l2 => { }
    end

    assert_redirected_to forum_cat_l2_path(assigns(:forum_cat_l2))
  end

  test "should show forum_cat_l2" do
    get :show, :id => forum_cat_l2s(:one).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => forum_cat_l2s(:one).id
    assert_response :success
  end

  test "should update forum_cat_l2" do
    put :update, :id => forum_cat_l2s(:one).id, :forum_cat_l2 => { }
    assert_redirected_to forum_cat_l2_path(assigns(:forum_cat_l2))
  end

  test "should destroy forum_cat_l2" do
    assert_difference('ForumCatL2.count', -1) do
      delete :destroy, :id => forum_cat_l2s(:one).id
    end

    assert_redirected_to forum_cat_l2s_path
  end
end
