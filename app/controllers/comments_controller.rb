class CommentsController < ApplicationController
  
  def show
  end
  
  def create
    
    commentable_type = params[:commentable_type]
    commentable_id = params[:commentable_id]
    @commentable = commentable_type.capitalize.constantize.find(commentable_id)    
    @comment = Comment.new(params[:comment])
    @comment.user_id = current_user.id
    @comment.recipient_id = @commentable.user_id  
    @commentable.comments << @comment         
    @newest_comment_id = params[:locator]
    respond_to do |format|
      format.js
    end    
  end
  
  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
  
    respond_to do |format|
      format.js
    end        
  end

end
