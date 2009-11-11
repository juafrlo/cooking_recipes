class RecetasController < ApplicationController

  before_filter :authorize, :only => [:new, :edit, :delete, :create, :update]
  before_filter :find_categories, :only => [:index,:new, :create, :edit, :update, :que_cocinar_hoy]
  before_filter :owner_required, :only => [:edit, :update]
  before_filter :admin_required, :only => [:destroy]
  before_filter :check_duration_is_integer, :only => [:resultados]

  require 'fileutils'
  
  # GET /recetas
  # GET /recetas.xml
  def index
    @recetas = Receta.find(:all, :order => 'created_at DESC', :limit => 5)
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @recetas }
    end
  end

  # GET /recetas/1
  # GET /recetas/1.xml
  def show
    @receta = Receta.find(params[:id])
    @ingredients = Ingredient.find(:all, :conditions => ["receta_id = ?", params[:id]])    
    @steps = Step.find(:all, :conditions => ["receta_id = ?", params[:id]])    
    @comment = Comment.new if logged_in?
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @receta }
      format.print { render :layout => "print"}
    end
  end

  # GET /recetas/new
  # GET /recetas/new.xml
  def new
    @receta = Receta.new
    
    3.times{ @receta.ingredients.build }
    3.times{ @receta.steps.build }

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @receta }
    end
  end

  # GET /recetas/1/edit
  def edit
    @receta = Receta.find(params[:id])
  end

  # POST /recetas
  # POST /recetas.xml
  def create
    @receta = Receta.new(params[:receta])
    @receta.user_id = current_user.id
        
    respond_to do |format|
      if @receta.save
        @receta.delphoto
        flash[:notice] = t(:receta_created)
        format.html { redirect_to(@receta) }
        format.xml  { render :xml => @receta, :status => :created, :location => @receta }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @receta.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /recetas/1
  # PUT /recetas/1.xml
  def update
    @receta = Receta.find(params[:id])

    respond_to do |format|
      if @receta.update_attributes(params[:receta])
        flash[:notice] = t(:receta_updated)
        format.html { redirect_to(@receta) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @receta.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /recetas/1
  # DELETE /recetas/1.xml
  def destroy
    @receta = Receta.find(params[:id])
    @receta.destroy

    respond_to do |format|
      format.html { redirect_to(recetas_url) }
      format.xml  { head :ok }
    end
  end
  
  def categoria
    @category = Category.find(params[:id])
    @recetas = @category.recetas.best_voted
    if @recetas.empty?
      flash[:notice] = t(:no_recetas_in_this_category)
      redirect_to(:back)
    end
  end

  def que_cocinar_hoy
    @receta = Receta.new    
    3.times{ @receta.ingredients.build }
  end
  
  def resultados
     if params[:receta][:name]
       @recetas = Receta.search(
         params[:receta][:name],
         params[:receta][:category_id],
         params[:receta][:country],
         params[:receta][:town]
       )
     else 
       @recetas_exact, @recetas_no_exact = Receta.search_with_ingr(
         params[:receta][:duration],
         params[:receta][:ingredient_attributes]
       )
    end
  end

  def resultados_busqueda
      @recetas = Receta.search(params[:receta][:name],params[:receta][:category_id],params[:receta][:country],params[:receta][:town])
  end  
  

  private
  def find_categories
    @categories = Category.find(:all, :order => 'name')    
  end
  
  def check_duration_is_integer
    if !params[:receta][:duration].blank? && params[:receta][:duration] != "0"
      if params[:receta][:duration].to_i == 0
        flash[:error] = t(:duration_must_be_integer)
        redirect_to que_cocinar_hoy_recetas_path 
      end
    end
  end
  
  

end
