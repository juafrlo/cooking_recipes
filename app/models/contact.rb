class Contact < ActiveRecord::Base
  validates_presence_of     :name
  validates_presence_of     :email
  validates_format_of       :email,    :with => Authentication.email_regex, :message => Authentication.bad_email_message
  validates_presence_of     :comment

  after_create :send_notification_to_admin
  
  def send_notification_to_admin
    UserMailer.deliver_contact_notification(self) 
  end
    
end
