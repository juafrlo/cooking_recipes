require 'test_helper'

class AdminsControllerTest < ActionController::TestCase

  test "admin should get index" do
    login_as :quentin
    get :index
    assert_response :success
    assert_select 'div#menu ul li', I18n.t(:Administration)
  end
  
  test "no admin should get index" do
    login_as :aaron
    get :index
    assert_response :redirect
    assert_select "div#menu", {:count=>0, :text=> I18n.t(:Administration) }
  end

end