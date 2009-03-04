class ForumPostsController < ApplicationController
  before_filter :authorize, :only => [:new, :edit, :delete]
  
  layout "forum_cat_l2s"

  # GET /forum_posts
  # GET /forum_posts.xml
  def index
    @forum_posts = ForumPost.find(:all)
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @forum_posts }
    end
  end

  # GET /forum_posts/1
  # GET /forum_posts/1.xml
  def show
    @forum_post = ForumPost.find(params[:id])
    @forum_post.comment = RedCloth.new(@forum_post.comment).to_html
  
    @forum_post.forum_replies.each do |forum_reply|
      forum_reply.reply = RedCloth.new(forum_reply.reply).to_html
    end 
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @forum_post }
    end
  end

  # GET /forum_posts/new
  # GET /forum_posts/new.xml
  def new
    @forum_cat_l2 = ForumCatL2.find(params[:forum_cat_l2_id])
    @forum_post = @forum_cat_l2.forum_posts.build

   respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @forum_post }
    end
  end

  # GET /forum_posts/1/edit
  def edit
    @forum_post = ForumPost.find(params[:id])
  end

  # POST /forum_posts
  # POST /forum_posts.xml
  def create
    @forum_cat_l2 = ForumCatL2.find(params[:forum_cat_l2_id])
    @forum_post = @forum_cat_l2.forum_posts.new(params[:forum_post])
    @forum_post.user_id = current_user.id    
    current_user.number_of_posts += 1  
    current_user.save!
      
    respond_to do |format|
      if @forum_post.save
        flash[:notice] = 'ForumPost was successfully created.'
        format.html { redirect_to(@forum_post) }
        format.xml  { render :xml => @forum_post, :status => :created, :location => @forum_post }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @forum_post.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /forum_posts/1
  # PUT /forum_posts/1.xml
  def update
    @forum_post = ForumPost.find(params[:id])

    respond_to do |format|
      if @forum_post.update_attributes(params[:forum_post])
        flash[:notice] = 'ForumPost was successfully updated.'
        format.html { redirect_to(@forum_post) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @forum_post.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /forum_posts/1
  # DELETE /forum_posts/1.xml
  def destroy
    @forum_post = ForumPost.find(params[:id])
    @forum_post.destroy

    respond_to do |format|
      format.html { redirect_to(forum_posts_url) }
      format.xml  { head :ok }
    end
  end
end
