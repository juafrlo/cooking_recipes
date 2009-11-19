class Comment < ActiveRecord::Base
  belongs_to :commentable, :polymorphic => true
  belongs_to :user
  belongs_to :recipient, :class_name => "User", :foreign_key => "recipient_id"

  after_create :send_notification_to_owner
  validates_presence_of :comment
  
  def send_notification_to_owner
    if self.recipient.receive_comments_emails && self.user != self.recipient
      UserMailer.deliver_comment_notification(self.recipient,self.commentable) 
    end
  end
  
end
