class Noticia < ActiveRecord::Base
	acts_as_commentable
	belongs_to :user
	
	named_scope :sorted, :order => 'created_at DESC'
  

  def to_param
    id.to_s << "-" << (title ? title.parameterize : '' )
  end
  
end
