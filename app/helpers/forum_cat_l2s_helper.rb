module ForumCatL2sHelper

def last_user(p)
  !p.forum_replies.empty? ?  p.forum_replies.last.user.login :  p.user.login 	
end
end
