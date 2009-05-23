class UsersController < ApplicationController
  # Be sure to include AuthenticationSystem in Application Controller instead
  include AuthenticatedSystem
  skip_before_filter :verify_authenticity_token, :only => 'auto_complete_for_user_login'
  before_filter :authorize, :only => [:mis_recetas]
 
 
  def show
    @user = User.find(params[:id])
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user }
    end
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
  def mis_recetas
    @recetas = Receta.find_ordered(current_user, :order => params[:order])
  end

  def mis_amigos
    @friends = current_user.user_friends
    @no_friends = current_user.user_no_friends
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
      flash[:notice] = "Gracias por registrarte. Te estamos enviando un email con tu código de activación."
    else
      flash[:error]  = "Lo sentimo, pero no ha sido posible crear tu cuenta.  Por favor, vuelve a intentarlo o ponte en contacto con nosotros."
      render :action => 'new'
    end
  end

  def update
    @user = User.find(params[:id])
    respond_to do |format|
      if @user.update_attributes(params[:user])
        flash[:notice] = 'Ficha de usuario actualizada.'
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
      flash[:notice] = "¡Registro completado! Por favor, introduce tu nombre de usuario y contraseña para continuar."
      redirect_to '/login'
    when params[:activation_code].blank?
      flash[:error] = "El código de activación no es correcto.  Por favor, utiliza la URL de tu email"
      redirect_back_or_default('/')
    else 
      flash[:error]  = "No pudimos encontrar un usuario con ese código de activación; comprueba tu email. Tal vez tu cuenta ya está activada. Prueba a introducir tu nombre de usuario y contraseña"
      redirect_back_or_default('/login')
    end
  end
end
