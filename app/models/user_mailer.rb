class UserMailer < ActionMailer::Base
  def signup_notification(user)
    setup_email(user)
    @subject    += I18n.t(:signup_notification_subject)
    @body[:url]  = "http://#{SITE_URL}/activate/#{user.activation_code}"
  end
 
  def activation(user)
    setup_email(user)
    @subject    += I18n.t(:activation_subject)
    @body[:url]  = "http://#{SITE_URL}/"
  end
  
  def reset_password(user)
    setup_email(user)
    @subject    += I18n.t(:reset_password_subject)
    @body[:url]  = "http://#{SITE_URL}/"
  end
 
  def comment_notification(user,obj)
    setup_email(user)
    if obj.class == Receta
      @subject    += I18n.t(:comment_receta_notification_subject)
    elsif obj.class == Advice
      @subject    += I18n.t(:comment_advice_notification_subject)
    elsif obj.class == Restaurant
      @subject    += I18n.t(:comment_restaurant_notification_subject)
    end
    @obj = obj
    if obj.class == Receta
      rel_path = receta_path(obj).to_s
    elsif obj.class == Advice
      rel_path = advice_path(obj).to_s
    elsif obj.class == Restaurant
      rel_path = restaurant_path(obj).to_s
    end    
    @body[:url] = "http://#{SITE_URL}/#{rel_path}"
  end
  
  def friend_notification(user,receta)
    setup_email(user)
    @subject += I18n.t(:friend_notification_subject)
    @receta = receta
    @body[:url]  = "http://#{SITE_URL}/#{receta_path(receta).to_s}"
  end
  
  def friendship_notification(user)
    setup_email(user)
    @subject += I18n.t(:friendship_notification_subject)
    @user = user
    @body[:url]  = "http://#{SITE_URL}/#{amigos_user_path(user).to_s}"
  end

  def message_notification(user)
    setup_email(user)
    @subject    += I18n.t(:message_notification_subject)
    @user = user
    @body[:url]  = "http://#{SITE_URL}/#{user_messages_path(user).to_s}"
  end

 
  protected
    def setup_email(user)
      @recipients  = "#{user.email}"
      @from        = "#{SITE_EMAIL}"
      @subject     = "#{SITE_NAME}: "
      @sent_on     = Time.now
      @body[:user] = user
    end
end