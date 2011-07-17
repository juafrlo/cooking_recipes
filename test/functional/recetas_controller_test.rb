require 'test_helper'

class RecetasControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:recetas)
  end

  test "should not get new" do
    get :new
    assert_response :redirect
  end

  test "should get new" do
    login_as :quentin
    get :new
    assert_response :success
  end


  test "should not create receta" do
    assert_no_difference('Receta.count') do
      post :create, :receta => { }
    end
    assert_response :redirect
  end

  test "should create receta" do
    login_as :quentin
    assert_difference('Receta.count') do
      post :create,
       :receta => {
         :name => 'Some name',
         :description => 'Some text',
         :duration => '20' }
    end
    assert_redirected_to receta_path(assigns(:receta))
  end


  test "should show receta" do
    get :show, :id => "name-#{recetas(:paella).id}"
    assert_response :success
  end

  test "should not get edit" do
    get :edit, :id => recetas(:paella).id
    assert_response :redirect
  end

  test "should get edit" do
    login_as :quentin
    get :edit, :id => recetas(:paella).id
    assert_response :success
  end

  test "should not update receta" do
    put :update, :id => recetas(:paella).id, :receta => { }
    assert_response :redirect
  end
  
  test "other user should not update receta" do
    login_as :aaron
    put :update, :id => recetas(:paella).id, :receta => { }
    assert_response :redirect
  end

  test "owner should update receta" do
    login_as :quentin
    put :update, :id => recetas(:paella).id, :receta => { }
    assert_redirected_to receta_path(recetas(:paella))
  end

  test "should not destroy receta" do
    assert_no_difference 'Receta.count' do
      delete :destroy, :id => recetas(:paella).id
    end
    assert_redirected_to '/'
  end
  
  test "other user should not destroy receta" do
    login_as :aaron
    assert_no_difference 'Receta.count' do
      delete :destroy, :id => recetas(:paella).id
    end
    assert_redirected_to '/'
  end

  test "admin should destroy receta" do
    login_as :quentin
    assert_difference('Receta.count',-1) do
      delete :destroy, :id => recetas(:paella).id
    end
    assert_redirected_to recetas_path
  end
  
  test "all users should access to categoria" do
    get :categoria, :id => 1
    assert_response :success
  end
  
  test "should get print version" do
    get :show, :formmat => :print, :id => "name-#{recetas(:paella).id}"
    assert_response :success
  end    
end
