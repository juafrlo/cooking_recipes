class ForumCatL1 < ActiveRecord::Base
  has_many :forum_cat_l2s, :dependent => :destroy
  
  def to_param
    id.to_s << "-" << (title ? title.parameterize : '' )
  end
  
end
