module FriendshipsHelper
  def friends_link(text,option,number = 0)
    link_to "#{text} #{show_count(option,number)}", 
      amigos_user_path(current_user,:option => option) 
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
  

=begin  
  def accept_friendship_link(user)
    link_to_remote 'Aceptar', spiner_my_friend_link_
	    :loading => "$('spiner_#{user.id}').show();",
	    :complete => "$('spiner_#{user.id}').hide();", 
	    :url => {:controller => 'friendships', :action => 'accept', 
		  :users => {:user_id => current_user.id, :friend_id => user.id}},
		  :html => {:id => "my_link_#{user.id}"}
  end
=end
  
  def deny_friendship_link(user)
    link_to_remote 'Rechazar',
	    :loading => "$('spiner_#{user.id}').show();",
	    :complete => "$('spiner_#{user.id}').hide();", 
	    :url => {:controller => 'friendships', :action => 'deny', 
		  :users => {:user_id => current_user.id, :friend_id => user.id}},
		:html => {:id => "my_link_#{user.id}"}
  end
  
  def invite_user_link(user, link_id, link_class)
    if current_user && current_user != user && current_user.can_invite.include?(user)
      link_to_remote 'Invitar amigo',
	  	  :loading => "$('spiner_#{link_id}').appear();",
	  	  :complete => "$('spiner_#{link_id}').hide();", 
	  	  :url => {:controller => 'friendships', :action => 'create',
          :link_id => link_id, :link_class => link_class, 
	  	    :users => {:user_id => current_user.id, :friend_id => user.id}},
	  		:html => {:id => link_id, :class => link_class}
    end
  end
end
