# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

def only_admin(text,link_path)
  if logged_in?  
 	 restrict_to "(admin) & !registered_user" do
 		 link_to text, link_path
 	 end 
  end
end


end
