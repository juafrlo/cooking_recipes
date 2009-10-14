class UserSweeper < ApplicationController::Caching::Swepper
  observe User

  def expire_cache(user)
     expire_fragment 'best_voted_chefs'
  end
end
