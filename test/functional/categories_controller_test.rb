require 'test_helper'

class CategoriesControllerTest < ActionController::TestCase
  def setup
    login_as :quentin
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:categories)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create category" do
    assert_difference('Category.count') do
      post :create,
       :category => {:categoryphoto =>fixture_file_upload('files/library.jpg', 'image/jpg') }
    end
    assert_redirected_to category_path(assigns(:category))
    FileUtils.rm_rf(Category::PREFIX_ROUTE + Category.last.id.to_s) 
  end

  test "should show category" do
    get :show, :id => categories(:one).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => categories(:one).id
    assert_response :success
  end

  test "should update category" do
    put :update, :id => categories(:one).id, :category => { }
    assert_redirected_to category_path(assigns(:category))
  end

  test "should destroy category" do
    assert_difference('Category.count', -1) do
      delete :destroy, :id => categories(:one).id
    end
    assert_redirected_to categories_path
  end

  test "no admin should be redirected" do
    no_admin_actions
  end

end
