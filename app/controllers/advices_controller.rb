class AdvicesController < ApplicationController
  before_filter :owner_required, :only => [:edit, :update]
  before_filter :admin_required, :only => [:destroy]
  before_filter :login_required, :only => [:new, :create]    

  # GET /advices
  # GET /advices.xml
  def index
    @advices = Advice.find(:all, :order => 'created_at DESC', :limit => 8)
    @cloud_advices = Advice.tag_counts
    @page_description = t(:advices_index_description)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @advices }
    end
  end

  # GET /advices/1
  # GET /advices/1.xml
  def show
    @advice = Advice.find(params[:id])
    @comment = Comment.new if logged_in?
    @page_description = @advice.description

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @advice }
      format.print { render :layout => "print"}
    end
  end

  # GET /advices/new
  # GET /advices/new.xml
  def new
    @advice = Advice.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @advice }
    end
  end

  # GET /advices/1/edit
  def edit
    @advice = @obj
  end

  # POST /advices
  # POST /advices.xml
  def create
    @advice = Advice.new(params[:advice])    
    @advice.user_id = current_user.id
    @advice.tag_list = params[:tag_list]

    respond_to do |format|
      if @advice.save
        flash[:notice] = t(:Advice_created)
        format.html { redirect_to(@advice) }
        format.xml  { render :xml => @advice, :status => :created, :location => @advice }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @advice.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /advices/1
  # PUT /advices/1.xml
  def update
    @advice = @obj
    @advice.tag_list = params[:tag_list]

    respond_to do |format|
      if @advice.update_attributes(params[:advice])
        flash[:notice] = t(:Advice_updated)
        format.html { redirect_to(@advice) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @advice.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /advices/1
  # DELETE /advices/1.xml
  def destroy
    @advice = Advice.find(params[:id])
    @advice.destroy

    respond_to do |format|
      flash[:notice] = t(:advice_deleted)
      format.html { redirect_to(advices_url) }
      format.xml  { head :ok }
    end
  end
  
  def buscador
    @page_description = t(:advices_searcher)
  end  
  
  def resultados
    if params[:tag_list].blank?
      @page_description = t(:advice_results)
    else
      head :moved_permanently, :location => tag_path(params[:tag_list].parameterize)
      return
    end
    @advices = Advice.search(params[:advice], params[:tag_list])
  end
  
  def tag
    @page_description = "#{t(:advice_results_by_tag)} #{params[:tag_list]}"
    @advices = Advice.search('', params[:id]) 
    render :template => 'advices/resultados'
  end
end
