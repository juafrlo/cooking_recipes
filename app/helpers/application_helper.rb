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

end
