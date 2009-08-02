module ForumCatL2sHelper

  def last_user(post)
    post.forum_replies.empty? ?  post.user : post.forum_replies.last.user
  end

end
