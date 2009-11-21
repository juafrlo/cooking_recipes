require 'test_helper'

class RestaurantsControllerTest < ActionController::TestCase
  fixtures :all
    
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:restaurants)
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

  test "should not create restaurant" do
    assert_no_difference('Restaurant.count') do
      post :create, :restaurant => { }
    end
  end
  
  test "should create restaurant" do
    login_as :quentin
    assert_difference('Restaurant.count') do
      post :create, :restaurant => {:name => 'Name', :description => 'Desc' }
    end
    assert_redirected_to restaurant_path(assigns(:restaurant))
  end
  
  test "should not create restaurant without name" do
    login_as :quentin
    assert_no_difference('Restaurant.count') do
      post :create, :restaurant => { }
    end
  end

  test "should show restaurant" do
    get :show, :id => restaurants(:one).id
    assert_response :success
  end

  test "should get edit" do
    login_as :quentin
    get :edit, :id => restaurants(:one).id
    assert_response :success
  end

  test "should not get edit of other restaurant" do
    login_as :aaron
    get :edit, :id => restaurants(:one).id
    assert_response :redirect
  end
  
  test "should not get edit" do
    get :edit, :id => restaurants(:one).id
    assert_response :redirect
  end
  
  test "should update restaurant" do
    login_as :quentin
    put :update, :id => restaurants(:one).id, :restaurant => { }
    assert_redirected_to restaurant_path(assigns(:restaurant))
  end

  test "should not update restaurant of other user" do
    login_as :aaron
    put :update, :id => restaurants(:one).id, :restaurant => { }
    assert_redirected_to '/'
  end

  test "should destroy restaurant" do
    login_as :quentin
    assert_difference('Restaurant.count', -1) do
      delete :destroy, :id => restaurants(:one).id
    end

    assert_redirected_to restaurants_path
  end

  test "should not destroy restaurant" do
    assert_no_difference 'Restaurant.count' do
      delete :destroy, :id => restaurants(:one).id
    end
    assert_redirected_to '/'
    login_as :aaron
    assert_no_difference 'Restaurant.count' do
      delete :destroy, :id => restaurants(:one).id
    end
    assert_redirected_to '/'
  end
  
  test "should get donde_puedo_comer" do
    get :donde_puedo_comer
    assert_response :success
  end

  test "should get resultados" do
    post :resultados, :restaurant => {:name => 'A name'}
    assert_response :success
  end

end
