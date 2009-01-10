class ForumPost < ActiveRecord::Base
  belongs_to :forum_cat_l2
  has_many :forum_replies
end
