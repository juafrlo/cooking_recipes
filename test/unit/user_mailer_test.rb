require File.dirname(__FILE__) + '/../test_helper'

class UserMailerTest < Test::Unit::TestCase
  def test_reset_password
    assert_difference 'ActionMailer::Base.deliveries.size', +1 do
      UserMailer.deliver_reset_password(users(:quentin))
    end
  end
  
  def test_comment_alarm
    assert_difference 'ActionMailer::Base.deliveries.size', +1 do
      UserMailer.deliver_comment_notification(users(:quentin), recetas(:paella))
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
