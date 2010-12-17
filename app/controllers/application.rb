# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include AuthenticatedSystem
  before_filter :find_seo_id
  before_filter :redirect_pages_without_www

  #Comment once all is correct
  #USERNAME, PASSWORD = "admin", "test"
  #before_filter :authenticate_with_http if RAILS_ENV == "production"


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
  def authenticate_with_http
    authenticate_or_request_with_http_basic do |username, password|
      username == USERNAME && password == PASSWORD
    end
  end
  
  def authorize
    unless logged_in?
      session[:protected_page] = request.request_uri
      flash[:notice] = "Por favor, haga login primero"
      head :moved_permanently, :location => '/login'
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
    @obj = controller_name.singularize.camelize.constantize.find(params[:id])
    if !current_user || !(@obj.user == current_user || current_user.admin?)
      head :moved_permanently, :location => '/'
    end
  end
  
  def find_seo_id
    unless params[:id].blank? || params[:action] == 'tag' || params[:controller] == 'rating' || params[:controller] == 'messages'
      seo_id = params[:id].scan(/.+-(.+)?/).to_s.to_i
      if seo_id != 0
        params[:id] = seo_id
      else
        old_id = params[:id].scan(/(\d+).+/).to_s
        unless request.url.include?(".print")
          head :moved_permanently, :location => request.url.gsub(/#{old_id}-/,'') << "-#{old_id}"
        else
          head :moved_permanently, :location => request.url.gsub(/#{old_id}-/,'').gsub('.print','') << "-#{old_id}.print"          
        end
      end
    end
  end
  
  def redirect_pages_without_www
    if RAILS_ENV == 'production' && request.host.scan(/^www./).blank?
      head :moved_permanently, :location => request.url.gsub('http://','http://www.')      
    end
  end
end