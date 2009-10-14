class RecetaSweeper < ApplicationController::Caching::Swepper
  observe Receta

  def expire_cache(receta)
     expire_fragment 'last_recipes_voted'
  end
end
