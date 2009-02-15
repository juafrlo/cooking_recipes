class ForumCatL2 < ActiveRecord::Base
  belongs_to :forum_cat_l1
  has_many :forum_posts
  
#  def self.get_last_updated(forum_cat_l2)
#    if ForumPost.find(forum_cat_l2.last_post)  ForumPost.find(forum_cat_l2.last_post) 
#        return ForumPost.find(forum_cat_l2.last_post)
#    else
#        return ForumPost.find(forum_cat_l2.last_post) 
#    end
#  end
end
