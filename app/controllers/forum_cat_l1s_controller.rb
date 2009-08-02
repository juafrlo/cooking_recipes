class ForumCatL1sController < ApplicationController
  # GET /forum_cat_l1s
  # GET /forum_cat_l1s.xml
  
  before_filter :admin_required
  
  def index
    @forum_cat_l1s = ForumCatL1.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @forum_cat_l1s }
    end
  end

  # GET /forum_cat_l1s/1
  # GET /forum_cat_l1s/1.xml
  def show
    @forum_cat_l1 = ForumCatL1.find(params[:id])
    @forum_cat_l2s = ForumCatL2.find(:all, :conditions => ["forum_cat_l1_id = ?", params[:id]])    


    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @forum_cat_l1 }
    end
  end

  # GET /forum_cat_l1s/new
  # GET /forum_cat_l1s/new.xml
  def new
    @forum_cat_l1 = ForumCatL1.new
        
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @forum_cat_l1 }
    end
  end

  # GET /forum_cat_l1s/1/edit
  def edit
    @forum_cat_l1 = ForumCatL1.find(params[:id])
  end

  # POST /forum_cat_l1s
  # POST /forum_cat_l1s.xml
  def create
    @forum_cat_l1 = ForumCatL1.new(params[:forum_cat_l1])

    respond_to do |format|
      if @forum_cat_l1.save
        flash[:notice] = t(:category1_created)
        format.html { redirect_to(@forum_cat_l1) }
        format.xml  { render :xml => @forum_cat_l1, :status => :created, :location => @forum_cat_l1 }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @forum_cat_l1.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /forum_cat_l1s/1
  # PUT /forum_cat_l1s/1.xml
  def update
    @forum_cat_l1 = ForumCatL1.find(params[:id])

    respond_to do |format|
      if @forum_cat_l1.update_attributes(params[:forum_cat_l1])
        flash[:notice] = t(:category_updated)
        format.html { redirect_to(@forum_cat_l1) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @forum_cat_l1.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /forum_cat_l1s/1
  # DELETE /forum_cat_l1s/1.xml
  def destroy
    @forum_cat_l1 = ForumCatL1.find(params[:id])
    @forum_cat_l1.destroy

    respond_to do |format|
      format.html { redirect_to(forum_cat_l1s_url) }
      format.xml  { head :ok }
    end
  end
end
