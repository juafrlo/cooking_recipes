class ForumCatL1 < ActiveRecord::Base
  has_many :forum_cat_l2s
end
