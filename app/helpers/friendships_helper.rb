module FriendshipsHelper
  def friends_link(text,option,number = 0)
    link_to "#{text} #{show_count(option,number)}", 
      mis_amigos_user_path(current_user,:option => option) 
  end

  def show_count(option,number)
    if number > 0 && option == "invitaciones_recibidas"
      "<span id= '#{option}' style='color:red;'>(#{number})</span>"
    elsif number > 0 && option != "invitaciones_recibidas"
      "<span id= '#{option}'>(#{number})</span>"
    else
      "<span id= '#{option}'></span>"
    end
  end
  
  
  def accept_friendship_link(user)
    link_to_remote 'Aceptar amistad',
	    :loading => "$('spiner_#{user.id}').show();",
	    :complete => "$('spiner_#{user.id}').hide();", 
	    :url => {:controller => 'friendships', :action => 'accept', 
		  :users => {:user_id => current_user.id, :friend_id => user.id}},
		  :html => {:id => "my_link_#{user.id}"}
  end
  
  def deny_friendship_link(user)
    link_to_remote 'Rechazar amistad',
	    :loading => "$('spiner_#{user.id}').show();",
	    :complete => "$('spiner_#{user.id}').hide();", 
	    :url => {:controller => 'friendships', :action => 'deny', 
		  :users => {:user_id => current_user.id, :friend_id => user.id}},
		:html => {:id => "my_link_#{user.id}"}
  end
  
  def invite_user_link(user)
    link_to_remote 'Invitar amigo',
		  :loading => "$('spiner_#{user.id}').show();",
		  :complete => "$('spiner_#{user.id}').hide();", 
		  :url => {:controller => 'friendships', :action => 'create', 
			:users => {:user_id => current_user.id, :friend_id => user.id}},
			:html => {:id => "my_link_#{user.id}"}
  end
end
