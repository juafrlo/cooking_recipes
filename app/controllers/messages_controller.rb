class MessagesController < ApplicationController
  
  before_filter :set_user
  before_filter :set_seo_id
  before_filter :same_user_required
  auto_complete_for :message, :to
  skip_before_filter :verify_authenticity_token, :only => [:auto_complete_for_message_to]
  
  def index
    if params[:mailbox] == "sent"
      @messages = @user.sent_messages
    else
      @messages = @user.received_messages
    end
  end
  
  def show
    @message = Message.read(params[:id], current_user)
  end
  
  def new
    @message = Message.new

    if params[:reply_to]
      @reply_to = @user.received_messages.find(params[:reply_to])
      unless @reply_to.nil?
        @message.to = @reply_to.sender.login
        @message.subject = "Re: #{@reply_to.subject}"
        @message.body = "\n\n*Mensaje original*\n\n #{@reply_to.body}"
      end
    end
  end
  
  def create
    @message = Message.new(params[:message])
    @message.sender = @user
    @message.recipient = User.find_by_login(params[:message][:to])

    if @message.save
      flash[:notice] = t(:Message_sent)
      redirect_to user_messages_path(@user)
    else
      render :action => :new
    end
  end
  
  def delete_selected
    if request.post?
      if params[:delete]
        params[:delete].each { |id|
          @message = Message.find(:first, :conditions => ["messages.id = ? AND (sender_id = ? OR recipient_id = ?)", id, @user, @user])
          @message.mark_deleted(@user) unless @message.nil?
        }
        flash[:notice] = t(:Messages_deleted)
      end
      redirect_to user_messages_path(@user)
    end
  end
  
  private
    def set_user
      if params[:user_id].scan(/.+(\d+)/).blank?
        seo_id = params[:user_id].scan(/.+-(.+)?/).to_s.to_i
      else
        seo_id = params[:user_id].scan(/.+-(\d+)/).flatten.first.to_i
      end
      @user = User.find(seo_id)
    end
    
    def set_seo_id
      if !params[:id].blank? && !params[:id].scan(/-(\d+)/).blank?
        params[:id] = params[:id].scan(/-(\d+)/).flatten.first.to_i
      end
    end
    
    def same_user_required
      if current_user.blank? || current_user != @user
        session[:protected_page] = request.request_uri
        flash[:notice] = "Por favor, haga login primero"
        head :moved_permanently, :location => '/login'
        return false        
      end
    end
end