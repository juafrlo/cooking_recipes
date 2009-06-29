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
  has_many :friendships, :dependent => :destroy
  has_private_messages

  validates_presence_of     :login
  validates_length_of       :login,    :within => 3..40
  validates_uniqueness_of   :login,    :onlu => 'create'
  validates_format_of       :login,    :with => Authentication.login_regex, :message => Authentication.bad_login_message

  validates_format_of       :name,     :with => Authentication.name_regex,  :message => Authentication.bad_name_message, :allow_nil => true
  validates_length_of       :name,     :maximum => 100

  validates_presence_of     :email
  validates_length_of       :email,    :within => 6..100 #r@a.wk
  validates_uniqueness_of   :email
  validates_format_of       :email,    :with => Authentication.email_regex, :message => Authentication.bad_email_message

  before_create :make_activation_code 

  # HACK HACK HACK -- how to do attr_accessible from here?
  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible :login, :email, :name, :password, :password_confirmation, :surname, :town, :country, :avatar


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
  
  def assignrole
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
       self.friends.collect(&:user_id) + [self.id]]) 
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
  
  def puntuation
    self.recetas.collect(&:puntuation).sum
  end

  def admin?
    User.first.roles.include?(Role.first) 
  end
  
  def is_admin?
    self.roles.include?(Role.find_by_title("admin")) ? true : false
  end
  
  def puntuation
    puntuations = []
    self.recetas.each do |r|
      puntuations << r.puntuation.to_i
    end
    puntuations.sum
  end
  
  def self.login_regexp(str)
    re = Regexp.new("^#{str}", "i")
    find_options = { :order => "login ASC" }
    @users = User.find(:all,
     find_options).collect(&:login).select { |login| login.match re }    
  end
  
  protected    
    def make_activation_code
        self.activation_code = self.class.make_token
    end



end
