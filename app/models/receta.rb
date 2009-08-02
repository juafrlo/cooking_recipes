class Receta < ActiveRecord::Base
  acts_as_rateable
  has_many :ingredients
  has_many :steps
  has_attached_file :photo,
   :styles => { :small => "150x150>"}
  after_update :save_steps
  belongs_to :user
  belongs_to :category
	acts_as_commentable
  
  validates_presence_of :name, :description, :country, :town
  validates_numericality_of :duration


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
    @cond = Array.new
    if !name.empty?
      @cond << "name like '%" + name + "%'"
    end
    if country && !country.empty?
      @cond << "country like '%" + country + "%'"
    end
    if town && !town.empty?
      @cond << "town like '%" + town + "%'"   
    end
    if category_id && !category_id.empty?
      @cond << "category_id = " + category_id  
    end
    
    @sql_statement = "SELECT * FROM recetas"
    @sql_statement += " WHERE " + @cond.join(' AND ') if @cond.size > 0  
    @sql_statement += " WHERE id = 0" if @cond.size == 0  
    @recetas = find_by_sql(@sql_statement)
  end
  
  
  
  
  
  
  
  def self.search_with_ingr(duration,ingredients)
    @ingr = Array.new
    ingredients.each do |ingr|
      @ingr << "'%"+ingr[:name]+"%'" 
    end
      
    # If some ingredient have been indicated
    @sql_statement = "SELECT *, COUNT(receta_id)  AS total FROM ingredients INNER JOIN recetas ON receta_id = recetas.id "      
    @sql_statement += "WHERE ingredients.name like " + @ingr.join(' OR ingredients.name like ')     if @ingr.size >=1
    if !duration.empty?
        @sql_statement += " AND " if @ingr.size >= 1        
        @sql_statement += " duration < " + duration
    end
    @sql_statement += " GROUP BY receta_id"


puts @sql_statement
    # If a name has benn indicated
    #if !name.empty? 
    #  @sql_statement = Receta.find_by_name("%"+ name + "%")
	  #end
	  
	  # Perform the query
	  @recetas = find_by_sql(@sql_statement)  
    
    # Count number of ingredients and get the exact recetas and no exact recetas in one array. 
    # The 'exact' field is for indicate how exact is the search
    # Compares number of times appear in last sql and number of ingredients searched
    @recetas_exact = Array.new            
    @recetas.each do |r|
      if r.total.to_i == @ingr.size.to_i
          r['exact'] = 1
          @recetas_exact << r               
      elsif (r.total.to_i >= (@ingr.size.to_i + 3)) || (r.total.to_i <= (@ingr.size.to_i + 3 ))
          r['exact'] = 0
          @recetas_exact << r     
      end 
    end

    @recetas_exact
end

  def self.find_ordered(user,options = {})
    with_scope :find => options do
      Receta.find(:all, :conditions => ["user_id = ?", user.id], :include => :category)
    end
  end
  
  
end
