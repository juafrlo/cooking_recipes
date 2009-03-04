module ForumPostsHelper
  
def login_edit(text,link_path)
  if logged_in? 
		if @forum_post.user_id = current_user.id 
	  		link_to text, link_path 
		 end 
	end
end  

end
