module RatingsHelper
  def num_votes(count_v)
    if count_v == 1
      count_v.to_s + ' voto'
    else
      count_v.to_s + ' votos'
    end
  end
  
  def rate_link(obj,num)
    class_hash = {
      "1" => 'one-star', "2" => 'two-stars', 
      "3" => 'three-stars', "4" => 'four-stars',
      "5" => 'five-stars'
    }
    link_to_remote(
      num,
      :url => rate_path(obj.id,:rating => num, :type => obj.class.to_s),
      :loading => "$('rating_spinner').appear();",	         
      :html => {:class => class_hash[num.to_s], :name => "#{num} star out of 5"}
    ) 
  end
end
