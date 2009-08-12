class Noticia < ActiveRecord::Base
	acts_as_commentable

  def to_param
    id.to_s << "-" << (title ? title.parameterize : '' )
  end
  
end
