class ForumCatL2 < ActiveRecord::Base
  belongs_to :forum_cat_l1
  has_many :forum_posts
end
