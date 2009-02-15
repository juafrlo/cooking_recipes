class ForumPost < ActiveRecord::Base
  belongs_to :forum_cat_l2
  has_many :forum_replies
  belongs_to :user

  after_create { |forum_post| update_last_post(forum_post) }
  after_update { |forum_post| update_last_post(forum_post) }
  
  def self.update_last_post(forum_post)
    @forum_cat_l2 = ForumCatL2.find(forum_post.forum_cat_l2_id)
    @forum_cat_l2.last_post_id = forum_post.id
    @forum_cat_l2.save!    
  end


end
