class Rating < ActiveRecord::Base
  validates_uniqueness_of :rateable_id, :scope => [:rateable_type, :user_id]

  def self.rate(obj_id,rating,type,current_user)
    r = Rating.create(:rateable_type => type, :rateable_id => obj_id,
                :rating => rating, :user_id => current_user.id)
  end
  
  def self.number_of_votes(type,obj)
    Rating.count(:all, :conditions => ['rateable_type = ? 
              AND rateable_id = ?', type, obj.id])
  end  
  
  def self.rating(obj,type)
    rating = Rating.average('rating', :conditions => ['rateable_type = ?
          AND rateable_id = ?', type, obj.id])        
    if rating.blank? 
      0
    else 
      rating.to_f
    end
  end
  
  def self.is_rated?(obj,current_user)
    r = Rating.find(:all, :conditions =>
     ['rateable_type = ? AND rateable_id = ? AND user_id = ?',
       obj.class.to_s,obj.id, current_user.id])
    r.size == 1 ? true : false
  end
    
end