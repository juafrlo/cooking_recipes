require 'test_helper'

class ContactTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "should send_notification_to_admin" do
    assert_difference 'ActionMailer::Base.deliveries.size' do
      Contact.create(:name => 'A name', :email => 'email@email.com',
       :comment => 'Some text')
    end    
  end
end
