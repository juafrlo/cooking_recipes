require 'test_helper'

class CommentTest < ActiveSupport::TestCase
  test "should_deliver_comment_notification" do
    assert_difference 'ActionMailer::Base.deliveries.size', +1 do
      create_comment(users(:aaron), users(:quentin))
    end
  end

  test "should_not_deliver_comment_notification" do
    assert_no_difference 'ActionMailer::Base.deliveries.size' do
      create_comment(users(:quentin), users(:aaron))
    end
  end  

  protected
  def create_comment(user,recipient)
    Comment.create(
      :user_id => user.id,
      :recipient_id => recipient.id,
      :commentable_type => "Receta",
      :commentable_id => 1,
      :comment => "Some text")
  end
end
