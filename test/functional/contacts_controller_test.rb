require 'test_helper'

class ContactsControllerTest < ActionController::TestCase
  fixtures :all
  
  # Replace this with your real tests.
  test "should get index" do
    get :index
    assert_response :success
  end
  
  test "should create contact" do
    assert_difference 'Contact.count', +1  do
      assert_difference 'ActionMailer::Base.deliveries.size' do
        post :create, :contact => {:name => 'A name',
          :email => 'email@email.com', :comment => 'Some text'}
      end
    end
  end
  
  test "should not create contact" do
    assert_no_difference 'Contact.count' do
      post :create, :contact => {:name => '',
        :email => '', :comment => ''}
    end
    contact = assigns(:contact)
    assert_not_nil contact.errors[:name]
    assert_not_nil contact.errors[:email]
    assert_not_nil contact.errors[:comment]    
  end
end
