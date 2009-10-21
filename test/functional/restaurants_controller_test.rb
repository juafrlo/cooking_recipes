require 'test_helper'

class RestaurantsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:restaurants)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create restaurant" do
    assert_difference('Restaurant.count') do
      post :create, :restaurant => { }
    end

    assert_redirected_to restaurant_path(assigns(:restaurant))
  end

  test "should show restaurant" do
    get :show, :id => restaurants(:one).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => restaurants(:one).id
    assert_response :success
  end

  test "should update restaurant" do
    put :update, :id => restaurants(:one).id, :restaurant => { }
    assert_redirected_to restaurant_path(assigns(:restaurant))
  end

  test "should destroy restaurant" do
    assert_difference('Restaurant.count', -1) do
      delete :destroy, :id => restaurants(:one).id
    end

    assert_redirected_to restaurants_path
  end
end
