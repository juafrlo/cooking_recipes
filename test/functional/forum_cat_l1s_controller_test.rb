require 'test_helper'

class ForumCatL1sControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:forum_cat_l1s)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create forum_cat_l1" do
    assert_difference('ForumCatL1.count') do
      post :create, :forum_cat_l1 => { }
    end

    assert_redirected_to forum_cat_l1_path(assigns(:forum_cat_l1))
  end

  test "should show forum_cat_l1" do
    get :show, :id => forum_cat_l1s(:one).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => forum_cat_l1s(:one).id
    assert_response :success
  end

  test "should update forum_cat_l1" do
    put :update, :id => forum_cat_l1s(:one).id, :forum_cat_l1 => { }
    assert_redirected_to forum_cat_l1_path(assigns(:forum_cat_l1))
  end

  test "should destroy forum_cat_l1" do
    assert_difference('ForumCatL1.count', -1) do
      delete :destroy, :id => forum_cat_l1s(:one).id
    end

    assert_redirected_to forum_cat_l1s_path
  end
end
