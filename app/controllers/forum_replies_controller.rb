class ForumRepliesController < ApplicationController
  before_filter :authorize, :only => [:new, :edit, :delete]
  
  layout "forum_cat_l2s"  
  
  # GET /forum_replies
  # GET /forum_replies.xml
  def index
    @forum_replies = ForumReply.find(:all)
    
  end

  # GET /forum_replies/1
  # GET /forum_replies/1.xml
  def show
    @forum_reply = ForumReply.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @forum_reply }
    end
  end

  # GET /forum_replies/new
  # GET /forum_replies/new.xml
  def new
    @forum_post = ForumPost.find(params[:forum_post_id])
    @forum_reply = @forum_post.forum_replies.build
    

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @forum_reply }
    end
  end

  # GET /forum_replies/1/edit
  def edit
    @forum_reply = ForumReply.find(params[:id])
  end

  # POST /forum_replies
  # POST /forum_replies.xml
  def create
    @forum_post = ForumPost.find(params[:forum_post_id])
    @forum_reply = @forum_post.forum_replies.new(params[:forum_reply])
    @forum_reply.user_id = current_user.id   
    current_user.number_of_posts += 1  
    current_user.save!

    if @forum_reply.save
        flash[:notice] = "Successfully created comment."
        redirect_to forum_post_url(@forum_reply.forum_post_id)
    else
        render :action => 'new'
    end
  
  end

  # PUT /forum_replies/1
  # PUT /forum_replies/1.xml
  def update
    @forum_reply = ForumReply.find(params[:id])

    respond_to do |format|
      if @forum_reply.update_attributes(params[:forum_reply])
        flash[:notice] = 'ForumReply was successfully updated.'
        format.html { redirect_to(@forum_reply) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @forum_reply.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /forum_replies/1
  # DELETE /forum_replies/1.xml
  def destroy
    @forum_reply = ForumReply.find(params[:id])
    @forum_reply.destroy

    respond_to do |format|
      format.html { redirect_to(forum_replies_url) }
      format.xml  { head :ok }
    end
  end
end
