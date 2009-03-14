class Category < ActiveRecord::Base
  has_many :recetas
  has_attached_file :categoryphoto  
end
