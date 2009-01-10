require 'test_helper'

class RecetasstepsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:recetassteps)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create recetasstep" do
    assert_difference('Recetasstep.count') do
      post :create, :recetasstep => { }
    end

    assert_redirected_to recetasstep_path(assigns(:recetasstep))
  end

  test "should show recetasstep" do
    get :show, :id => recetassteps(:one).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => recetassteps(:one).id
    assert_response :success
  end

  test "should update recetasstep" do
    put :update, :id => recetassteps(:one).id, :recetasstep => { }
    assert_redirected_to recetasstep_path(assigns(:recetasstep))
  end

  test "should destroy recetasstep" do
    assert_difference('Recetasstep.count', -1) do
      delete :destroy, :id => recetassteps(:one).id
    end

    assert_redirected_to recetassteps_path
  end
end
