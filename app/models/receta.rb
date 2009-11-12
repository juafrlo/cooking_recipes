class Receta < ActiveRecord::Base
  acts_as_rateable
  has_many :ingredients
  has_many :steps
  has_attached_file :photo, :styles => { :small => "150x150>"}
  after_update :save_steps
  belongs_to :user
  belongs_to :category
	acts_as_commentable
  acts_as_favorite
  
  validates_presence_of :name, :description, :duration
  validates_numericality_of :duration
  
  after_create :send_notification_to_friends

  named_scope :best_voted, :order => "ratings.rating DESC", :include => 'ratings'
  

  def ingredient_attributes=(ingredient_attributes)
    ingredient_attributes.each do |attributes|
      if attributes[:id].blank?
        ingredients.build(attributes)
      else
        ingredient = ingredients.detect { |t| t.id == attributes[:id].to_i }
        ingredient.attributes = attributes
      end  
    end
  end
  
  def save_ingredients
    ingredients.each do |t|
      if t.should_destroy?
        t.destroy
      else
        t.save(false)
      end
    end
  end

   
  def step_attributes=(step_attributes)
    step_attributes.each do |attributes|
      if attributes[:id].blank?
        steps.build(attributes)
      else
        step = steps.detect { |t| t.id == attributes[:id].to_i }
        step.attributes = attributes
      end  
    end
  end
  
  def save_steps
    steps.each do |t|
      if t.should_destroy?
        t.destroy
      else
        t.save(false)
      end
    end
  end
  
  def delphoto
    unless photo_file_name.nil?
      if FileTest.exists?("#{RAILS_ROOT}/public/system/photos/" + id.to_s + "/original/" + photo_file_name) 
        FileUtils.rm_rf("#{RAILS_ROOT}/public/system/photos/" + id.to_s + "/original/") 
      else
        Directory("#{RAILS_ROOT}/public/system/photos/" + id.to_s + "/original")
      end
    end
  end
  
  def self.search(name,category_id,country,town)
    cond = Array.new
    unless name.blank?
      cond << "name like '%" + name + "%'"
    end
    unless country.blank?
      cond << "country like '%" + country + "%'"
    end
    unless town.blank?
      cond << "town like '%" + town + "%'"   
    end
    unless category_id.blank?
      cond << "category_id = " + category_id  
    end
    sql_statement = "SELECT * FROM recetas"
    sql_statement += " WHERE " + cond.join(' AND ') if cond.size > 0  
    sql_statement += " WHERE id = 0" if cond.size == 0  
    recetas = find_by_sql(sql_statement)
  end
  
  def to_param
    id.to_s << "-" << (name ? name.parameterize : '' )
  end
    
  def self.search_with_ingr(duration,ingredients)
    ingr = Array.new
    ingredients.each do |ingredient|
      ingr << "'%"+ingredient[:name]+"%'" unless ingredient[:name].blank?
    end
      
    # If some ingredient have been indicated
    sql_statement = "SELECT *, COUNT(receta_id) AS total
     FROM ingredients INNER JOIN recetas ON receta_id = recetas.id "      
    if ingr.size >=1
      sql_statement += "WHERE (ingredients.name like " + ingr.join(' OR ingredients.name like ') + ")"  
    end
    unless duration.blank?
        sql_statement += ingr.size >= 1  ? " AND " : " WHERE "        
        sql_statement += " duration <= #{duration.to_i}"
    end
    sql_statement += " GROUP BY receta_id"

	  # Perform the query
	  recetas = find_by_sql(sql_statement)  
    
    # Count number of ingredients and get the exact recetas and no exact recetas in two arrays. 
    # Compares number of times appear in last sql and number of ingredients searched
    recetas_exact = Array.new      
    recetas_no_exact = Array.new      

    recetas.each do |r|
      if r.total.to_i == ingr.size.to_i || (ingr.size == 0 && !duration.blank?)  
          recetas_exact << r               
      elsif ingr.size != 0 && 
      ((r.total.to_i >= (ingr.size.to_i + 3)) || (r.total.to_i <= (ingr.size.to_i + 3 )))
          recetas_no_exact << r  
      end 
    end
    [recetas_exact, recetas_no_exact]
  end

  def self.find_ordered(user,options = {})
    with_scope :find => options do
      Receta.find(:all, :include => [:ratings, :category],
       :conditions => ["recetas.user_id = ?", user.id])
    end
  end  
  
  def send_notification_to_friends
    self.user.friends.each do |friend|
      if friend.receive_friends_emails
        UserMailer.deliver_friend_notification(friend,self) 
      end
    end
  end
  
  def self.top(limit = 5)
    Receta.find(:all, :include => 'ratings', :limit => limit, 
      :order => "ratings.rating DESC, recetas.created_at DESC")
  end
  
  def self.top_by_category(cat_id)
    Receta.find(:all, :include => 'ratings',
      :conditions => {:category_id => cat_id},
      :order => "ratings.rating DESC")
  end
  
  def self.last_voted(limit = 5)
    Receta.find(:all, :include => :ratings,
     :limit => limit, :order => 'ratings.created_at DESC',
     :conditions => ["ratings.rating IS NOT ?", nil])
  end
    
end
