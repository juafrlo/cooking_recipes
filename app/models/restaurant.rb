class Restaurant < ActiveRecord::Base
  acts_as_rateable
  belongs_to :user
  belongs_to :rest_category
  has_attached_file :photo, :styles => { :small => "150x150>"}
  acts_as_commentable
	validates_presence_of :name, :description
	validates_numericality_of :creator_rating,
	 :only_integer => true, :greater_than_or_equal_to => 0, :less_than_or_equal_to => 5
	
	named_scope :best_voted, :order => "ratings.rating DESC", :include => 'ratings'
  
	
	def to_param
    id.to_s << "-" << (name ? name.parameterize : '' )
  end
    
end
