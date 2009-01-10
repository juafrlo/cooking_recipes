class Receta < ActiveRecord::Base
  has_many :steps
  after_update :save_steps
   
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

end
