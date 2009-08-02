require 'test_helper'

class ForumPostsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:forum_posts)
  end

  test "should get new" do
    login_as :quentin
    get :new, :forum_cat_l2_id => 1
    assert_response :success
  end

  test "should not get new" do
    get :new, :forum_cat_l2_id => 1
    assert_response :redirect
  end

  test "should create forum_post" do
    login_as :aaron
    assert_difference('ForumPost.count') do
      post :create,
       :forum_post => {:title => 'Some title', :comment => 'Other' },
       :forum_cat_l2_id => 1
    end
    assert_equal assigns(:forum_post).comment, 'Other'
    assert_redirected_to forum_post_path(assigns(:forum_post))
  end

  test "should not create forum_post" do
    assert_no_difference('ForumPost.count') do
      post :create, :forum_post => { }, :forum_cat_l2_id => 1
    end
  end

  test "should show forum_post" do
    get :show, :id => forum_posts(:one).id, :forum_cat_l2_id => 1
    assert_response :success
  end

  test "should get edit" do
    login_as :aaron
    get :edit, :id => forum_posts(:four).id, :forum_cat_l2_id => 1
    assert_response :success
  end

  test "other user should not get edit" do
    login_as :old_password_holder
    get :edit, :id => forum_posts(:four).id, :forum_cat_l2_id => 1
    assert_response :redirect
  end


  test "should not get edit" do
    get :edit, :id => forum_posts(:one).id, :forum_cat_l2_id => 1
    assert_response :redirect
  end

  test "should update forum_post" do
    login_as :aaron
    put :update, :id => forum_posts(:four).id, 
     :forum_post => {:comment => 'Other' }
    assert_equal assigns(:forum_post).comment, 'Other'
    assert_redirected_to forum_post_path(assigns(:forum_post))
  end

  test "other user should not update forum_post" do
    login_as :old_password_holder
    put :update, :id => forum_posts(:four).id, 
     :forum_post => {:comment => 'Other' }
    assert_redirected_to '/'
  end


  test "should not update forum_post" do
    put :update, :id => forum_posts(:one).id,
     :forum_post => {:comment => 'Other' }    
    assert_redirected_to :login
  end

  test "should destroy forum_post" do
    login_as :quentin
    count1 = ForumReply.find(:all,
     :conditions => ['forum_post_id = ?', forum_posts(:one).id]).size
    assert_difference('ForumPost.count', -1) do
      delete :destroy, :id => forum_posts(:one).id
    end
    assert_not_equal count1, 
     ForumReply.find(:all,
     :conditions => ['forum_post_id = ?', forum_posts(:one).id]).size    
    assert_redirected_to forum_cat_l2_path(forum_posts(:one).forum_cat_l2)
  end

  test "should not destroy forum_post" do
    assert_no_difference 'ForumPost.count' do
      delete :destroy, :id => forum_posts(:one).id
    end
  end


end
