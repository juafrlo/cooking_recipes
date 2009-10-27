class Restaurant < ActiveRecord::Base
  acts_as_rateable
  belongs_to :user
  has_attached_file :photo, :styles => { :small => "150x150>"}
  acts_as_commentable
	validates_presence_of :name, :description
	
	def to_param
    id.to_s << "-" << (name ? name.parameterize : '' )
  end
    
end
