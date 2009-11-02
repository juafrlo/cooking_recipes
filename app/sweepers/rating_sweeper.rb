class RatingSweeper < ActionController::Caching::Sweeper
  observe Rating

  def after_save(rating)
    expire_cache(rating)
  end
  
  def after_destroy(rating)
    expire_cache(rating)
  end

  def expire_cache(rating)
    if rating.rateable_type == "Restaurant"
      expire_fragment 'best_restaurants'
      expire_fragment 'best_restaurant_critics'
    elsif rating.rateable_type == "Advice"
      expire_fragment 'best_advices'
      expire_fragment 'best_advicers'
    else
      expire_fragment 'best_recipes'
      expire_fragment 'best_voted_chefs'
    end
  end
end
