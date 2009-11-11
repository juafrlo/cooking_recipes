class Advice < ActiveRecord::Base
  acts_as_taggable
  acts_as_rateable
  acts_as_commentable
  acts_as_favorite
  belongs_to :user
  validates_presence_of :name, :description
  
  named_scope :by_name, lambda {|name|
    name.blank? ? {} : {:conditions => ["name like ?", "%#{name}%"]}} 
  named_scope :by_description, lambda {|description|
    description.blank? ? {} : {:conditions => ["description like ?", "%#{description}%"]}} 
  named_scope :best_voted, :order => "ratings.rating DESC", :include => 'ratings'
  
  
  def to_param
    id.to_s << "-" << (name ? name.parameterize : '' )
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
  
  def self.search(options = {}, tags = "")
    scope = Advice.scoped({})    
    scope = scope.by_name(options[:name]) 
    scope = scope.by_description(options[:description]) 
    scope = scope.best_voted 
    scope = scope.find_tagged_with(tags) unless tags.empty?
    scope     
  end
  
  def self.find_ordered(user,options = {})
    with_scope :find => options do
      Advice.find(:all, :include => [:ratings],
       :conditions => ["advices.user_id = ?", user.id])
    end
  end  
end
