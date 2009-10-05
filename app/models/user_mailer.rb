class UserMailer < ActionMailer::Base
  def signup_notification(user)
    setup_email(user)
    @subject    += "Por favor, activa tu cuenta"
    @body[:url]  = "http://#{SITE_URL}/activate/#{user.activation_code}"
  end
 
  def activation(user)
    setup_email(user)
    @subject    += "¡Cuenta activada!"
    @body[:url]  = "http://#{SITE_URL}/"
  end
  
  def reset_password(user)
    setup_email(user)
    @subject    += "Tu password ha sido reseteado"
    @body[:url]  = "http://#{SITE_URL}/"
  end
 
  def comment_notification(user,receta)
   setup_email(user)
   @subject    += "Has recibido un comentario en unas de tus recetas"
   @receta = receta
   @body[:url]  = "http://#{SITE_URL}/#{receta_path(receta).to_s}"
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