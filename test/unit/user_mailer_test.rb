require File.dirname(__FILE__) + '/../test_helper'

class UserMailerTest < Test::Unit::TestCase
  def test_reset_password
    assert_difference 'ActionMailer::Base.deliveries.size', +1 do
      UserMailer.deliver_reset_password(users(:quentin))
    end
  end
  
  def test_comment_notification
    assert_difference 'ActionMailer::Base.deliveries.size', +1 do
      UserMailer.deliver_comment_notification(users(:quentin), recetas(:paella))
    end
  end

  def test_friend_notification
    assert_difference 'ActionMailer::Base.deliveries.size', +1 do
      UserMailer.deliver_friend_notification(users(:quentin), recetas(:paella))
    end
  end

  def test_friendship_notification
    assert_difference 'ActionMailer::Base.deliveries.size', +1 do
      UserMailer.deliver_friendship_notification(users(:aaron))
    end
  end
  
  def test_comment_notification
    assert_difference 'ActionMailer::Base.deliveries.size', +1 do
      UserMailer.deliver_message_notification(users(:quentin))
    end
  end

  def test_contact_notification
    assert_difference 'ActionMailer::Base.deliveries.size', +1 do
      UserMailer.deliver_contact_notification(contacts(:one))
    end
  end


  private
    def read_fixture(action)
      IO.readlines("#{FIXTURES_PATH}/user_mailer/#{action}")
    end

    def encode(subject)
      quoted_printable(subject, CHARSET)
    end
end
