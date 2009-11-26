module NoticiasHelper
  def what_to_do(image,option,intro,path)
    html = "<div class='index_option'>"
      html += "<div class='photo'>" + 
           link_to(image_tag(image, :size => "70x70", :alt => 'option'), path)  +
        "</div>"
      html += "<div class='content'>"
    	 html += "<span>" + link_to(option,path) + "</span>"
    	 html += "<div>" + intro + "</div>"
    	html += "</div>"
    html +="</div>"
  end

end
