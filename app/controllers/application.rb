# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include AuthenticatedSystem

  helper :all # include all helpers, all the time
  #before_filter :set_locale

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '08168a9889846ca9c99a58dbc1f9411e'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password

  # if params[:locale] is nil then I18n.default_locale will be used
  #def set_locale
  #  I18n.locale = params[:locale]
  #end

  private
  def authorize
    unless logged_in?
      session[:protected_page] = request.request_uri
      flash[:notice] = "Por favor, haga login primero"
      redirect_to(:controller => 'sessions', :action => 'new')
      return false
    end      
  end
    
  def login_and_return
    session[:return_url] = request.env["HTTP_REFERER"]
  end    
 
  def admin_required
    unless current_user &&
    current_user.roles.include?(Role.find_by_title("admin"))
      redirect_to '/'
    end
  end 
  
  def owner_required
    case controller_name
      when "forum_posts"
        @forum_post = ForumPost.find(params[:id])
        if !(@forum_post.user == current_user || current_user.admin?)
          redirect_to '/'
        end
      when "forum_replies"
        @forum_reply = ForumReply.find(params[:id])
        if !(@forum_reply.user == current_user || current_user.admin?)
          redirect_to '/'
        end
      when "recetas"
        @receta = Receta.find(params[:id])
        if !(@receta.user == current_user || current_user.admin?)
          redirect_to '/'
        end
      when "restaurants"
        @restaurant = Restaurant.find(params[:id])
        if !current_user || !(@restaurant.user == current_user || current_user.admin?)
          redirect_to '/'
        end
      when "advices"
        @advice = Advice.find(params[:id])
        if !current_user || !(@current_user.user == current_user || current_user.admin?)
          redirect_to '/'
        end
    end
  end
end
