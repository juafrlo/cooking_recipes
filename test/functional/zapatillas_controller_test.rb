require 'test_helper'

class ZapatillasControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:zapatillas)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create zapatilla" do
    assert_difference('Zapatilla.count') do
      post :create, :zapatilla => { }
    end

    assert_redirected_to zapatilla_path(assigns(:zapatilla))
  end

  test "should show zapatilla" do
    get :show, :id => zapatillas(:one).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => zapatillas(:one).id
    assert_response :success
  end

  test "should update zapatilla" do
    put :update, :id => zapatillas(:one).id, :zapatilla => { }
    assert_redirected_to zapatilla_path(assigns(:zapatilla))
  end

  test "should destroy zapatilla" do
    assert_difference('Zapatilla.count', -1) do
      delete :destroy, :id => zapatillas(:one).id
    end

    assert_redirected_to zapatillas_path
  end
end
