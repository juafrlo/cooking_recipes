class Rating < ActiveRecord::Base
  def self.rate(object_id,rating,type,current_user)
    Rating.delete_all(["rateable_type = ? AND rateable_id = ? AND user_id = ?", 
                       type, object_id, current_user.id])
    r = Rating.new(:rateable_type => type, :rateable_id => object_id,
                :rating => rating, :user_id => current_user.id)
    r.save!
  end
  
  def self.number_of_votes(type,object)
    Rating.count(:all, :conditions => ['rateable_type = ? 
              AND rateable_id = ?', type, object.id])
  end  
  
  def self.rating(object,type)
    rating = Rating.average('rating', :conditions => ['rateable_type = ?
          AND rateable_id = ?', type, object.id])        
    if rating.blank? 
      0
    else 
      rating.to_f
    end
  end
  
  def self.is_rated?(type,object,current_user)
    r = Rating.find(:all, :conditions => ['rateable_type = ? 
              AND rateable_id = ?', type,object.id])
    r.size == 1 ? true : false
  end
    
end