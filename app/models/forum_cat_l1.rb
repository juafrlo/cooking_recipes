class ForumCatL1 < ActiveRecord::Base
  has_many :forum_cat_l2s, :dependent => :destroy
  
  def to_param
    (title ? title.parameterize : '' ) << "-" << id.to_s
  end
  
end
