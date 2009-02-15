class ForumReply < ActiveRecord::Base
  belongs_to :forum_post
  belongs_to :user
  
  after_create { |forum_reply| update_last_reply(forum_reply) }
  after_update { |forum_reply| update_last_reply(forum_reply) }
  
  def self.update_last_reply(forum_reply)
    @forum_cat_l2 = ForumCatL2.find(forum_reply.forum_post.forum_cat_l2_id)
    @forum_cat_l2.last_post_id = forum_reply.forum_post_id
    @forum_cat_l2.save!    
  end
    
end
