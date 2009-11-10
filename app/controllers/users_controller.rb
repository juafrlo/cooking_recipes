class UsersController < ApplicationController

  # Be sure to include AuthenticationSystem in Application Controller instead
  include AuthenticatedSystem
  skip_before_filter :verify_authenticity_token, :only => 'auto_complete_for_user_login'
  before_filter :login_required, :only => 'auto_complete_for_user_login'
  before_filter :be_same_user, :only => [:edit, :update, :amigos]
  before_filter :find_user, :only => [:recetas, :recetas_favoritas, :restaurantes,
     :restaurantes_favoritos, :consejos, :consejos_favoritos]
   
  def show
    @user = User.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user }
    end
  end
  
  def edit
  end
  
  def amigos
    @users,@title = @user.friends_list(params[:option])   
  end

  def auto_complete_for_user_login
    @users = User.login_regexp(params[:message][:to])
    render :inline =>
     "<%= content_tag(:ul, @users.map { |user| content_tag(:li, h(user)) }) %>"
  end

  # render new.rhtml
  def new
    @user = User.new
  end
 
  def create
    logout_keeping_session!
    @user = User.new(params[:user])
    success = @user && @user.save
    @user.assignrole
    @user.delavatar
    if success && @user.errors.empty?        	  
      redirect_back_or_default('/')
      flash[:notice] = t(:sign_up_complete)
    else
      flash[:error]  = t(:sign_up_failed)
      render :action => 'new'
    end
  end

  def update
    @user = User.find(params[:id])
    respond_to do |format|
      if @user.update_attributes(params[:user])
        flash[:notice] = t(:user_data_updated)
        format.html { redirect_to(@user) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  def activate
    logout_keeping_session!
    user = User.find_by_activation_code(params[:activation_code]) unless params[:activation_code].blank?
    case
    when (!params[:activation_code].blank?) && user && !user.active?
      user.activate!
      flash[:notice] = t(:activation_success)
      redirect_to '/login'
    when params[:activation_code].blank?
      flash[:error] = t(:activation_failed)
      redirect_back_or_default('/')
    else 
      flash[:error]  = t(:activation_error_user)
      redirect_back_or_default('/login')
    end
  end
  
  def forgot_password  
    @user = User.find_by_email(params[:email])  
    if @user && @user.reset_password
      UserMailer.deliver_reset_password(@user)
      @user.save
      redirect_to login_url
      flash[:notice] = t(:your_password_has_been_reset_and_emailed_to_you)
    else
      flash[:error] = t(:sorry_we_dont_recognize_that_email_address)
    end 
  end
  
  def recetas
    @recetas = Receta.find_ordered(@user, :order => params[:order])
  end
    
  def recetas_favoritas
    @recetas = @user.favorite_recetas
  end
  
  def restaurantes
    @restaurants = Restaurant.find_ordered(@user, :order => params[:order])
  end

  def restaurantes_favoritos
    @restaurants = @user.favorite_restaurants
  end
  
  def consejos
    @advices = Advice.find_ordered(@user, :order => params[:order])
  end
  
  def consejos_favoritos
    @advices = @user.favorite_advices
  end
  
  protected
  def find_user
    @user = User.find(params[:id])
  end
  
  def be_same_user
    @user = User.find(params[:id])
    redirect_to '/' unless (current_user && (current_user == @user || current_user.admin?))
  end
end
