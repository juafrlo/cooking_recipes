module MessagesHelper
  def message_user(cond,usr)
    if cond
	    link_to(t(:You), user_path(usr)) 
    else 
    	link_to(h(usr.login), user_path(usr))
    end 
  end
end
