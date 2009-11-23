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
  
  def receta_show_photo(receta)
		if !receta.photo_file_name.nil? 
      html = link_to_redbox(image_tag(receta.photo.url(:small), :alt => receta.name), 'bigger_image') 
      html += "<div id='bigger_image' style='display:none;'>"
			html += link_to_close_redbox(image_tag('web/close.png'), :class => 'close_button')
      html += "<div class='redbox_photo'>"
      html += image_tag(receta.photo.url(:small), :size => "300x300") 
      html += "</div>"
      html += "</div>"
		else 
			image_tag('others/no_photo.jpg')
		end
  end
  
end
