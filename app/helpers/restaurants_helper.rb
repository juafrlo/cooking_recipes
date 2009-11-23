module RestaurantsHelper
  def restaurant_show_photo(restaurant)
		unless restaurant.photo_file_name.blank?
			html = link_to_redbox(image_tag(restaurant.photo.url(:small), :alt => restaurant.name),
			 'bigger_image') 
      html += "<div id='bigger_image' style='display:none;'>"
			html += link_to_close_redbox(image_tag('web/close.png'), :class => 'close_button')
      html += "<div class='redbox_photo'>"
      html += image_tag(restaurant.photo.url(:small), :size => "300x300") 
      html += "</div>"
      html += "</div>"
      
		else 
			image_tag('others/no_photo.jpg')
		end
  end
end
