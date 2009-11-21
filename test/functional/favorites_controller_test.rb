require 'test_helper'

class FavoritesControllerTest < ActionController::TestCase
  test "should create favorite" do
    login_as :quentin
    assert_difference 'Favorite.count' do 
      post :create, :type => 'Receta', :obj_id => 1
    end
  end
  
  test "should destroy favorite" do
    login_as :quentin
    assert_difference 'Favorite.count', -1 do 
      delete :destroy, :id => 2, :type => "Receta"
    end
  end
  
  test "should not create favorite" do
    assert_no_difference 'Favorite.count' do 
      post :create, :type => 'Receta', :obj_id => 1
    end
  end
  
  test "should not destroy other user favorite" do
    login_as :aaron
    assert_no_difference 'Favorite.count' do 
      delete :destroy, :id => 1, :type => "Receta"
    end
  end

  test "should not destroy favorite without login" do
    assert_no_difference 'Favorite.count', -1 do 
      delete :destroy, :id => 1
    end
  end
end