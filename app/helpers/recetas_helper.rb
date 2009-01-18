module RecetasHelper
  def add_ingredient_link(name)
    link_to_function name do |page| 
  			page.insert_html :bottom, :ingredients, :partial => 'ingredient', :object => Ingredient.new
  	end
  end

  def add_step_link(name)
    link_to_function name do |page| 
  			page.insert_html :bottom, :steps, :partial => 'step', :object => Step.new
  	end
  end
end
