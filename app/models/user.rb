require 'digest/sha1'

class User < ActiveRecord::Base
  include Authentication
  include Authentication::ByPassword
  include Authentication::ByCookieToken
  has_and_belongs_to_many :roles
  has_many :forum_posts
  has_many :replies
  has_attached_file :avatar, :styles => { :small => "50x50>" }, :default_url => "/images/avatars/small/missing.png"
  has_many :recetas
  has_many :ratings
  has_many :friendships, :dependent => :destroy
  has_private_messages
  has_many :restaurants
  has_many :advices
  
  acts_as_favorite_user

  validates_presence_of     :login
  validates_length_of       :login,    :within => 3..40
  validates_uniqueness_of   :login,    :only => 'create'
  validates_format_of       :login,    :with => Authentication.login_regex, :message => Authentication.bad_login_message

  validates_format_of       :name,     :with => Authentication.name_regex,  :message => Authentication.bad_name_message, :allow_nil => true
  validates_length_of       :name,     :maximum => 100

  validates_presence_of     :email
  validates_length_of       :email,    :within => 6..100 #r@a.wk
  validates_uniqueness_of   :email
  validates_format_of       :email,    :with => Authentication.email_regex, :message => Authentication.bad_email_message

  validates_acceptance_of   :terms_of_service,    :on => :create

  before_create :make_activation_code 

  # HACK HACK HACK -- how to do attr_accessible from here?
  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible :login, :email, :name, :password, :password_confirmation, :surname,
   :town, :country, :avatar, :receive_comments_emails, :receive_friends_emails,
   :receive_friendships_emails, :receive_messages_emails, :terms_of_service
  
  # Activates the user in the database.
  def activate!
    @activated = true
    self.activated_at = Time.now.utc
    self.activation_code = nil
    save(false)
  end

  # Returns true if the user has just been activated.
  def recently_activated?
    @activated
  end

  def active?
    # the existence of an activation code means they have not activated yet
    activation_code.nil?
  end

  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  #
  # uff.  this is really an authorization, not authentication routine.  
  # We really need a Dispatch Chain here or something.
  # This will also let us return a human error message.
  #
  def self.authenticate(login, password)
    return nil if login.blank? || password.blank?
    u = find :first, :conditions => ['login = ? and activated_at IS NOT NULL', login] # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end

  def login=(value)
    write_attribute :login, (value ? value.downcase : nil)
  end

  def email=(value)
    write_attribute :email, (value ? value.downcase : nil)
  end

  def delavatar
    unless avatar_file_name.nil?
      if FileTest.exists?("#{RAILS_ROOT}/public/system/avatars/" + id.to_s + "/original/" + avatar_file_name) 
        FileUtils.rm_rf("#{RAILS_ROOT}/public/system/avatars/" + id.to_s + "/original/") 
      else
        Directory("#{RAILS_ROOT}/public/system/avatars/" + id.to_s + "/original")
      end
    end
  end
  
  def assign_role
    debugger
    roles << Role.find(2)
    save!  
  end
  
  def friends_ids
    self.friendships.select{|user|
      user.status == Friendship::STATUS[1] }.collect(&:friend_id)
  end
    
  def friends
    User.find(:all, :conditions => ['id IN (?)', friends_ids],
     :order => 'login ASC')
  end
  
  def invited_friends
    invited_friends = self.friendships.select{
      |user| user.status == Friendship::STATUS[0] && user.initiator == true
    }.collect(&:friend_id)
    User.find(:all, :conditions => ['id IN (?)', invited_friends])
  end
  
  def can_invite
    pending_or_accepted =  self.friendships.collect(&:friend_id) 
    User.find(:all, :conditions => ['id NOT IN (?)', pending_or_accepted + [self.id]])
  end
  
  def received_invitations
    users_invited_user = Friendship.all.select { |user| 
      user.friend_id == self.id && user.status == Friendship::STATUS[0] && user.initiator == true
    }.collect(&:user_id)
    User.find(:all, :conditions => ['id IN (?)', users_invited_user])
  end
  
  def no_friends  
    User.find(:all, :conditions => ['id NOT IN (?)',
       self.friends.collect(&:id) + [self.id]]) 
  end
  
  
  def friends_list(option)
    case option
      when 'mis_amigos'
        users = self.friends
        title = 'Mis amigos'
      when 'invitar'
        users = self.can_invite
        title = "Mandar invitaciones"
      when 'invitados'
        users = self.invited_friends
        title = "Usuarios invitados"
      when 'invitaciones_recibidas'
        users = self.received_invitations
        title = "Invitaciones recibidas"
      else
        users = self.friends
        title = "Mis amigos"
    end 
    [users,title]
  end
  
  def update_recetas_avg
    ratings = []
    self.recetas.each do |receta|
      ratings << receta.rating
    end
    self.recetas_avg = (ratings.sum/ratings.size).to_f
    self.save!
  end
  
  def update_restaurants_avg
    ratings = []
    self.restaurants.each do |restaurant|
      ratings << restaurant.rating
    end
    self.restaurants_avg = (ratings.sum/ratings.size).to_f
    self.save!    
  end

  def update_advices_avg
    ratings = []
    self.advices.each do |advice|
      ratings << advice.rating
    end
    self.advices_avg = (ratings.sum/ratings.size).to_f
    self.save!    
  end



  def admin?
    self.roles.include?(Role.find_by_title("admin")) ? true : false
  end
    
  def self.login_regexp(str)
    re = Regexp.new("^#{str}", "i")
    find_options = { :order => "login ASC" }
    @users = User.find(:all,
     find_options).collect(&:login).select { |login| login.match re }    
  end
  
  def to_param
    id.to_s << "-" << (login ? login.parameterize : '' )
  end
  
  def reset_password
     new_password = newpass(8)
     self.password = new_password
     self.password_confirmation = new_password
     return self.valid?
  end
  
  def newpass( len )
     chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
     new_password = ""
     1.upto(len) { |i| new_password << chars[rand(chars.size-1)] }
     return new_password
  end
  
  def self.top(limit = 5)
    User.find(:all, :limit => limit, :order => "recetas_avg DESC",
      :conditions => 'recetas_avg > 0.0')
  end
  
  def self.top_restaurant_critics(limit = 5)
    User.find(:all, :limit => limit, :order => "restaurants_avg DESC",
      :conditions => 'restaurants_avg > 0.0')
  end

  def self.top_advicers(limit = 5)
    User.find(:all, :limit => limit, :order => "advices_avg DESC",
      :conditions => 'advices_avg > 0.0')
  end

  def self.first_admin
    User.find(:first, :include => [:roles],
     :conditions => {"roles.title" => 'admin'})
  end
      
  protected    
  def make_activation_code
    self.activation_code = self.class.make_token
  end
end