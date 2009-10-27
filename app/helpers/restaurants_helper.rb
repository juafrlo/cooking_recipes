module RestaurantsHelper
  def restaurant_show_photo(restaurant)
		unless restaurant.photo_file_name.blank?
			image_tag restaurant.photo.url(:small) 
		else 
			image_tag('others/no_photo.jpg')
		end
  end
end
