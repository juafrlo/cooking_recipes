require 'test_helper'

class MessageTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end

  test "should deliver message notification" do
    assert_difference 'ActionMailer::Base.deliveries.size', +1 do
      Message.create(
        :sender_id => users(:quentin).id,
        :recipient_id => users(:aaron).id
        )
    end
  end

  test "should not deliver message notification" do
    assert_no_difference 'ActionMailer::Base.deliveries.size' do
      Message.create(
        :sender_id => users(:aaron).id,
        :recipient_id => users(:quentin).id
        )
    end
  end


end
