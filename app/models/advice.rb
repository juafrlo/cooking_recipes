class Advice < ActiveRecord::Base
  acts_as_taggable
  acts_as_rateable
  acts_as_commentable
  acts_as_favorite
  belongs_to :user
  validates_presence_of :name, :description
  after_create :send_notification_to_friends
  
  named_scope :by_name, lambda {|name|
    name.blank? ? {} : {:conditions => ["name like ?", "%#{name}%"]}} 
  named_scope :by_description, lambda {|description|
    description.blank? ? {} : {:conditions => ["description like ?", "%#{description}%"]}} 
  named_scope :best_voted, :order => "ratings.rating DESC", :include => 'ratings'
  
  
  def to_param
    (name ? name.parameterize : '' ) << "-" << id.to_s
  end

  def self.top(limit = 5)
    Advice.find(:all, :include => 'ratings', :limit => limit, 
      :order => "ratings.rating DESC, advices.created_at DESC")
  end
    
  def self.last_voted(limit = 5)
    Advice.find(:all, :include => :ratings,
     :limit => limit, :order => 'ratings.created_at DESC',
     :conditions => ["ratings.rating IS NOT ?", nil])
  end
  
  def send_notification_to_friends
    self.user.friends.each do |friend|
      if friend.receive_friends_emails
        UserMailer.deliver_friend_notification(friend,self) 
      end
    end
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
