class Category < ActiveRecord::Base
  has_many :recetas
  has_attached_file :categoryphoto, :styles => { :small => "172x150>" }
  
  

  def delcategoryphoto
    unless categoryphoto_file_name.nil?
      if FileTest.exists?("#{RAILS_ROOT}/public/system/categoryphotos/" + id.to_s + "/original/" + categoryphoto_file_name) 
        FileUtils.rm_rf("#{RAILS_ROOT}/public/system/categoryphotos/" + id.to_s + "/original/") 
      else
        Directory("#{RAILS_ROOT}/public/system/categoryphotos/" + id.to_s + "/original")
      end
    end
  end  
  
  
end
