require 'test_helper'

class NoticiasControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:noticias)
  end

  test "should get new" do
    login_as :quentin
    get :new
    assert_response :success
  end

  test "should not get new" do
    get :new
    assert_response :redirect
  end


  test "should create noticia" do
    login_as :quentin
    assert_difference('Noticia.count') do
      post :create, :noticia => { }
    end

    assert_redirected_to noticia_path(assigns(:noticia))
  end

  test "should not create noticia" do
    assert_no_difference('Noticia.count') do
      post :create, :noticia => { }
    end
    assert_redirected_to '/'
  end

  test "should show noticia" do
    get :show, :id => "name-#{noticias(:one).id}"
    assert_response :success
  end

  test "should get edit" do
    login_as :quentin
    get :edit, :id => noticias(:one).id
    assert_response :success
  end

  test "should not get edit" do
    get :edit, :id => noticias(:one).id
    assert_response :redirect
  end


  test "should update noticia" do
    login_as :quentin
    put :update, :id => noticias(:one).id, :noticia => { }
    assert_redirected_to noticia_path(assigns(:noticia))
  end

  test "should not update noticia" do
    put :update, :id => noticias(:one).id, :noticia => { }
    assert_redirected_to '/'
  end

  test "should not destroy noticia" do
    assert_no_difference('Noticia.count') do
      delete :destroy, :id => noticias(:one).id
    end
    assert_redirected_to '/'
  end
end
