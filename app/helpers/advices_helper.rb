module AdvicesHelper
  def advices_tags(advice)
    html = ""
    advice.tags.each do |tag|
      html += link_to(tag.name, tag_path(tag))
      html += ", " unless tag == advice.tags.last
    end
    html
  end
  
end
