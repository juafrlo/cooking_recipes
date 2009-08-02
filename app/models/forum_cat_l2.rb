class ForumCatL2 < ActiveRecord::Base
  belongs_to :forum_cat_l1
  has_many :forum_posts, :dependent => :destroy
  
  def last_post
    ForumPost.find(self.last_post_id) if self.last_post_id
  end

  def to_param
    id.to_s << "-" << (title ? title.parameterize : '' )
  end
end
