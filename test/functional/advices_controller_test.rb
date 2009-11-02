require 'test_helper'

class AdvicesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:advices)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create advice" do
    assert_difference('Advice.count') do
      post :create, :advice => { }
    end

    assert_redirected_to advice_path(assigns(:advice))
  end

  test "should show advice" do
    get :show, :id => advices(:one).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => advices(:one).id
    assert_response :success
  end

  test "should update advice" do
    put :update, :id => advices(:one).id, :advice => { }
    assert_redirected_to advice_path(assigns(:advice))
  end

  test "should destroy advice" do
    assert_difference('Advice.count', -1) do
      delete :destroy, :id => advices(:one).id
    end

    assert_redirected_to advices_path
  end
end
