require File.dirname(__FILE__) + '/../test_helper'
require 'users_controller'

# Re-raise errors caught by the controller.
class UsersController; def rescue_action(e) raise e end; end

class UsersControllerTest < ActionController::TestCase
  # Be sure to include AuthenticatedTestHelper in test/test_helper.rb instead
  # Then, you can remove it from this and the units test.
  include AuthenticatedTestHelper
  fixtures :all

  def test_should_allow_signup
    assert_difference 'User.count' do
      assert_difference 'ActionMailer::Base.deliveries.size' do
        create_user
      end
    end
  end

  def test_should_require_login_on_signup
    assert_no_difference 'User.count' do
      create_user(:login => nil)
    end
  end

  def test_should_require_password_on_signup
    assert_no_difference 'User.count' do
      user_test = create_user(:password => nil)
      assert user_test.errors.on(:password)
    end
  end

  def test_should_require_password_confirmation_on_signup
    assert_no_difference 'User.count' do
      user_test = create_user(:password_confirmation => nil)
      assert user_test.errors.on(:password_confirmation)
    end
  end

  def test_should_require_email_on_signup
    assert_no_difference 'User.count' do
      user_test = create_user(:email => nil)
      assert user_test.errors.on(:email)
    end
  end
  
  def test_should_sign_up_user_with_activation_code
    user_test = create_user
    assert_not_nil user_test.activation_code
  end

  def test_should_activate_user
    assert_nil User.authenticate('aaron', 'test')
    get :activate, :activation_code => users(:aaron).activation_code
    assert_redirected_to '/login'
    assert_not_nil flash[:notice]
    assert_equal users(:aaron), User.authenticate('aaron', 'monkey')
  end
  
  def test_should_not_activate_user_without_key
    get :activate
    assert_nil flash[:notice]
  rescue ActionController::RoutingError
    # in the event your routes deny this, we'll just bow out gracefully.
  end

  def test_should_not_activate_user_with_blank_key
    get :activate, :activation_code => ''
    assert_nil flash[:notice]
  rescue ActionController::RoutingError
    # well played, sir
  end
  
  def test_should_edit_user_info
    login_as :quentin
    get :edit, :id => users(:quentin).id
    assert_response :success
  end

  def test_should_not_edit_user_info
    login_as :aaron
    get :edit, :id => users(:quentin).id
    assert_response :redirect
  end
    
  def test_should_get_amigos
    login_as :quentin
    get :amigos, :id => users(:quentin).id
    assert_response :success
  end
  
  def test_should_not_get_amigos
    get :amigos, :id => users(:quentin).id
    assert_response :redirect
  end
  
  def test_should_update
    login_as :quentin
    put :update, :id => users(:quentin).id,
      :user => {:town =>"New town", :receive_comments_emails => true,
        :receive_friends_emails => true}
    assert_equal assigns(:user).town, "New town"
    assert_equal assigns(:user).receive_comments_emails, true
    assert_equal assigns(:user).receive_friends_emails, true
    assert_redirected_to user_path(users(:quentin))
  end

  def test_should_reset_password
    assert_difference 'ActionMailer::Base.deliveries.size', 1 do
      post :forgot_password, :email => users(:quentin).email
      assert_redirected_to login_path    
    end
  end

  test "should get user recetas" do
    get :recetas, :id => 1
    assert_response :success
  end

  test "should get user favorite recetas" do
    get :recetas_favoritas, :id => 1
    assert_response :success
  end
  
  test "should get user restaurants" do
    get :restaurantes, :id => 1
    assert_response :success
  end

  test "should get user favorite restaurants" do
    get :restaurantes_favoritos, :id => 1
    assert_response :success
  end

  test "should get user advices" do
    get :consejos, :id => 1
    assert_response :success
  end

  test "should get user favorite advices" do
    get :consejos_favoritos, :id => 1
    assert_response :success
  end


  protected
    def create_user(options = {})
      hash = {:login => 'quire', :email => 'quire@example.com',
        :password => 'quire69', :password_confirmation => 'quire69' }.merge(options)
      User.create(hash) 
    end
end
