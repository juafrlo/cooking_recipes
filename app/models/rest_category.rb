class RestCategory < ActiveRecord::Base
  has_many :restaurants
  if RAILS_ENV == "test"
    CATEGORIES_PHOTOS_PATH = ":rails_root/test/fixtures/files/:id/:style/:basename.:extension"
    PREFIX_ROUTE = "#{RAILS_ROOT}/test/fixtures/files/"
  else
    CATEGORIES_PHOTOS_PATH = ":rails_root/public/system/:attachment/:id/:style/:basename.:extension" 
    PREFIX_ROUTE = "#{RAILS_ROOT}/public/system/restcategoryphotos/"
  end
  has_attached_file :restcategoryphoto,
   :styles => {:small => "172x150"},
   :path => Category::CATEGORIES_PHOTOS_PATH
  
  def delcategoryphoto(prefix_route)
    category_route = prefix_route + id.to_s + "/original/"
    if !restcategoryphoto_file_name.nil? &&  
      FileTest.exists?(category_route + restcategoryphoto_file_name) 
        FileUtils.rm_rf(category_route) 
    end
  end  
  
  def to_param
    (name ? name.parameterize : '' ) << "-" << id.to_s
  end
end
