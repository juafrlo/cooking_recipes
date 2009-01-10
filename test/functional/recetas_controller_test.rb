require 'test_helper'

class RecetasControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:recetas)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create receta" do
    assert_difference('Receta.count') do
      post :create, :receta => { }
    end

    assert_redirected_to receta_path(assigns(:receta))
  end

  test "should show receta" do
    get :show, :id => recetas(:one).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => recetas(:one).id
    assert_response :success
  end

  test "should update receta" do
    put :update, :id => recetas(:one).id, :receta => { }
    assert_redirected_to receta_path(assigns(:receta))
  end

  test "should destroy receta" do
    assert_difference('Receta.count', -1) do
      delete :destroy, :id => recetas(:one).id
    end

    assert_redirected_to recetas_path
  end
end
