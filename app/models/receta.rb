class Receta < ActiveRecord::Base
  has_many :ingredients
  has_many :steps
  has_attached_file :photo, :styles => { :small => "150x150>"}
  after_update :save_steps

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

end
