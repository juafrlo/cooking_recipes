class Restaurant < ActiveRecord::Base
  acts_as_rateable
  belongs_to :user
  belongs_to :rest_category
  has_attached_file :photo, :styles => { :small => "150x150>"}
  acts_as_commentable
	validates_presence_of :name, :description
	validates_numericality_of :creator_rating, 
	 :greater_than_or_equal_to => 0, :less_than_or_equal_to => 5,
	 :unless => lambda {|restaurant| restaurant.creator_rating.blank? }
	validates_numericality_of :avg_price, :greater_than_or_equal_to => 0,
	 :unless => lambda {|restaurant| restaurant.avg_price.blank? }
  
	
	named_scope :best_voted, :order => "ratings.rating DESC", :include => 'ratings'
  named_scope :by_name, lambda {|name|
    name.blank? ? {} : {:conditions => ["name like ?", "%#{name}%"]}} 
  named_scope :by_specialty,  lambda {|cat|
    cat.blank? ? {} : {:conditions => {:rest_category_id => cat}}}
  named_scope :by_country,  lambda {|country|
    country.blank? ? {} : {:conditions => ["country like ?", "%#{country}%"]}} 
  named_scope :by_original_country,  lambda {|country|
    country.blank? ? {} : {:conditions => ["original_country like ?", "%#{country}%"]}} 
  named_scope :by_town,  lambda {|town|
    town.blank? ? {} : {:conditions => ["town like ?", "%#{town}%"]}} 
  named_scope :by_description,  lambda {|desc|
    desc.blank? ? {} : {:conditions => ["description like ?", "%#{desc}%"]}} 
  named_scope :by_creator_rating,  lambda {|rating|
    rating.blank? ? {} : {:conditions => ["creator_rating >= ?", rating]}} 
  named_scope :by_avg_price,  lambda {|price|
    price.blank? ? {} : {:conditions => ["avg_price <= ?", price]}} 
    
    
	def to_param
    id.to_s << "-" << (name ? name.parameterize : '' )
  end
  
  def self.search(options = {})
    scope = Restaurant.scoped({})    
    scope = scope.by_name(options[:name]) 
    scope = scope.by_specialty(options[:rest_category_id]) 
    scope = scope.by_country(options[:country]) 
    scope = scope.by_original_country(options[:original_country]) 
    scope = scope.by_town(options[:town]) 
    scope = scope.by_description(options[:description]) 
    scope = scope.by_creator_rating(options[:creator_rating]) 
    scope = scope.by_avg_price(options[:avg_price]) 
    scope = scope.best_voted
    scope     
  end
    
end
