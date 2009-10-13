class Message < ActiveRecord::Base
  is_private_message
  attr_accessor :to
  after_create :send_notification_to_user
  
  protected
  def send_notification_to_user
    if self.recipient.receive_messages_emails
      UserMailer.deliver_message_notification(self.recipient) 
    end
  end  
end