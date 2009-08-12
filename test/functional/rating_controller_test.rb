require 'test_helper'

class RatingControllerTest < ActionController::TestCase
  test "should rate" do
    login_as :quentin
    post :rate, :id => "2", :rating => 2, :type => "Receta"
    assert_response :success
  end

  test "should not rate" do
    post :rate, :id => "2", :rating => 2, :type => "Receta"
    assert_response :redirect
  end


end