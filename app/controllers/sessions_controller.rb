# This controller handles the login/logout function of the site.  
class SessionsController < ApplicationController
  before_filter :login_and_return, :only => [:new]
  
  # Be sure to include AuthenticationSystem in Application Controller instead
  include AuthenticatedSystem

  # render new.rhtml
  def new
    params[controller_name]
  end

  def create
    logout_keeping_session!
    user = User.authenticate(params[:login], params[:password])
    if user
      # Protects against session fixation attacks, causes request forgery
      # protection if user resubmits an earlier form using back
      # button. Uncomment if you understand the tradeoffs.
      # reset_session
      self.current_user = user
      new_cookie_flag = (params[:remember_me] == "1")
      handle_remember_cookie! new_cookie_flag
      if (redirect_url = session[:protected_page])
        session[:protected_page] = nil
        redirect_to redirect_url
      elsif (redirect_url = session[:return_url])
        session[:return_url] = nil
        redirect_to redirect_url
      else
        redirect_back_or_default('/')
      end
      flash[:notice] = t(:session_created)
    else
      note_failed_signin
      @login       = params[:login]
      @remember_me = params[:remember_me]
      render :action => 'new'
    end
  end

  def destroy
    logout_killing_session!
    flash[:notice] = t(:session_destroyed)
    request.env["HTTP_REFERER"].nil? ? redirect_to('/') : redirect_to(:back)  
  end

protected
  # Track failed login attempts
  def note_failed_signin
    flash[:error] = "No has podido entrar en el sistema como '#{params[:login]}'"
    logger.warn "Failed login for '#{params[:login]}' from #{request.remote_ip} at #{Time.now.utc}"
  end
end
