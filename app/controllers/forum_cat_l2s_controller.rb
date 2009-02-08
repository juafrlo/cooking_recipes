class ForumCatL2sController < ApplicationController
  # GET /forum_cat_l2s
  # GET /forum_cat_l2s.xml
  def index
    @forum_cat_l2s = ForumCatL2.find(:all)
    @categories = ForumCatL1.find(:all)
    
    logger.debug(@categories[0].title)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @forum_cat_l2s }
    end
  end

  # GET /forum_cat_l2s/1
  # GET /forum_cat_l2s/1.xml
  def show
    @forum_cat_l2 = ForumCatL2.find(params[:id])
    @forum_posts = ForumPost.find(:all, :conditions => ["forum_cat_l2_id = ?", params[:id]])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @forum_cat_l2 }
    end
  end

  # GET /forum_cat_l2s/new
  # GET /forum_cat_l2s/new.xml
  def new
    @forum_cat_l2 = ForumCatL2.new
    @forum_cat_l1s = ForumCatL1.find(:all)

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @forum_cat_l2 }
    end
  end

  # GET /forum_cat_l2s/1/edit
  def edit
    @forum_cat_l2 = ForumCatL2.find(params[:id])
    @forum_cat_l1s = ForumCatL1.find(:all)
  end

  # POST /forum_cat_l2s
  # POST /forum_cat_l2s.xml
  def create
    @forum_cat_l2 = ForumCatL2.new(params[:forum_cat_l2])

    respond_to do |format|
      if @forum_cat_l2.save
        flash[:notice] = 'ForumCatL2 was successfully created.'
        format.html { redirect_to(@forum_cat_l2) }
        format.xml  { render :xml => @forum_cat_l2, :status => :created, :location => @forum_cat_l2 }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @forum_cat_l2.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /forum_cat_l2s/1
  # PUT /forum_cat_l2s/1.xml
  def update
    @forum_cat_l2 = ForumCatL2.find(params[:id])

    respond_to do |format|
      if @forum_cat_l2.update_attributes(params[:forum_cat_l2])
        flash[:notice] = 'ForumCatL2 was successfully updated.'
        format.html { redirect_to(@forum_cat_l2) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @forum_cat_l2.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /forum_cat_l2s/1
  # DELETE /forum_cat_l2s/1.xml
  def destroy
    @forum_cat_l2 = ForumCatL2.find(params[:id])
    @forum_cat_l2.destroy

    respond_to do |format|
      format.html { redirect_to(forum_cat_l2s_url) }
      format.xml  { head :ok }
    end
  end
end
