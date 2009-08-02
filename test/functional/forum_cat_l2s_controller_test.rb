require 'test_helper'

class ForumCatL2sControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:forum_cat_l2s)
    assert_select "a", {:count=>0, :text=> I18n.t(:new_forum_cat_l2) }
    assert assigns(:forum_cat_l2s)
  end
  
  test "should view new category link" do
    login_as :quentin
    get :index
    assert_select "a", {:count=>1, :text=> I18n.t(:new_forum_cat_l2) }    
  end

  test "should not get new" do
    login_as :aaron 
    get :new
    assert_response :redirect
  end

  test "should get new" do
    login_as :quentin
    get :new
    assert_response :success
  end

  test "should not create forum_cat_l2" do
    login_as :aaron
    assert_no_difference('ForumCatL2.count') do
      post :create, :forum_cat_l2 => { }
    end
    assert_redirected_to '/'
  end

  test "should create forum_cat_l2" do
    login_as :quentin
    assert_difference('ForumCatL2.count') do
      post :create, :forum_cat_l2 => { }
    end
    assert_redirected_to forum_cat_l2_path(assigns(:forum_cat_l2))
  end

  test "should show forum_cat_l2" do
    get :show, :id => forum_cat_l2s(:one).id
    assert_response :success
  end

  test "should not get edit" do
    login_as :aaron
    get :edit, :id => forum_cat_l2s(:one).id
    assert_response :redirect
  end

  test "should get edit" do
    login_as :quentin
    get :edit, :id => forum_cat_l2s(:one).id
    assert_response :success
  end

  test "should not update forum_cat_l2" do
    login_as :aaron
    old_title = forum_cat_l2s(:one).title
    put :update, :id => forum_cat_l2s(:one).id,
     :forum_cat_l2 => {:title => 'Some title' }
    assert_equal ForumCatL2.find(1).title, old_title
    assert_redirected_to '/'
  end


  test "should update forum_cat_l2" do
    login_as :quentin
    put :update, :id => forum_cat_l2s(:one).id,
     :forum_cat_l2 => {:title => 'Some title'}
    assert_equal ForumCatL2.find(1).title, 'Some title'
    assert_redirected_to forum_cat_l2_path(assigns(:forum_cat_l2))
  end

  test "should not destroy forum_cat_l2" do
    login_as :aaron
    assert_no_difference('ForumCatL2.count') do
      delete :destroy, :id => forum_cat_l2s(:one).id
    end
    assert_redirected_to '/'
  end

  test "should destroy forum_cat_l2" do
    login_as :quentin
    count1 = ForumPost.find(:all,
     :conditions => ['forum_cat_l2_id = ?', forum_cat_l2s(:one).id]).size
    assert_difference('ForumCatL2.count', -1) do
      delete :destroy, :id => forum_cat_l2s(:one).id
    end
    assert_not_equal count1, 
     ForumPost.find(:all,
      :conditions => ['forum_cat_l2_id = ?', forum_cat_l2s(:one).id]).size    
    assert_redirected_to forum_cat_l2s_path
  end
end
