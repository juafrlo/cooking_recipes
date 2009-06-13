# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

def only_admin(text,link_path)
  if logged_in?  
 	 restrict_to "admin) & !registered_user" do
 		 link_to text, link_path
 	 end 
  end
end


def log_in_out()
  if !logged_in?
		link_to 'Login',  '/login' 
	else 
		link_to 'Logout',  '/logout'
	end 
end

def hello_user(user)
  if logged_in?
    '<span>Hola, '+user.login + '</span> | '
  end
end

def user_unread_messages
  if current_user.unread_message_count > 0
    if current_user.unread_message_count == 1
      "(#{current_user.unread_message_count} mensaje)"
    else
      "(#{current_user.unread_message_count} mensajes)"
    end
  end
end

def mydatetime_format(datetime)
   datetime.strftime('%d/%m/%Y %H:%M:%S')
end

end
