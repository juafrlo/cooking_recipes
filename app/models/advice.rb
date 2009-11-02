class Advice < ActiveRecord::Base
  acts_as_taggable
  acts_as_rateable
  belongs_to :user
  validates_presence_of :title, :description
  
  def to_param
    id.to_s << "-" << (title ? title.parameterize : '' )
  end

  def self.top(limit = 5)
    Advice.find(:all, :include => 'ratings', :limit => limit, 
      :order => "ratings.rating DESC")
  end
    
  def self.last_voted(limit = 5)
    Advice.find(:all, :include => :ratings,
     :limit => limit, :order => 'ratings.created_at DESC',
     :conditions => ["ratings.rating IS NOT ?", nil])
  end
end
