require 'test_helper'

class RestCategoriesControllerTest < ActionController::TestCase
  def setup
    login_as :quentin
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:rest_categories)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create rest_category" do
    assert_difference('RestCategory.count') do
      post :create,
       :rest_category => {:restcategoryphoto => fixture_file_upload('files/library.jpg', 'image/jpg') }
    end
    assert_redirected_to rest_category_path(assigns(:rest_category))
    FileUtils.rm_rf(RestCategory::PREFIX_ROUTE + RestCategory.last.id.to_s) 
  end

  test "should show rest_category" do
    get :show, :id => "name-#{rest_categories(:one).id}"
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => rest_categories(:one).id
    assert_response :success
  end

  test "should update rest_category" do
    put :update, :id => rest_categories(:one).id, :rest_category => { }
    assert_redirected_to rest_category_path(assigns(:rest_category))
  end

  test "should destroy rest_category" do
    assert_difference('RestCategory.count', -1) do
      delete :destroy, :id => rest_categories(:one).id
    end
    assert_redirected_to rest_categories_path
  end

  test "no admin should be redirected" do
    no_admin_actions
  end

end
