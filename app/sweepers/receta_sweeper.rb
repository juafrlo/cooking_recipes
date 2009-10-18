class RecetaSweeper < ActionController::Caching::Sweeper
  observe Receta

  def after_save(receta)
    expire_cache(receta)
  end
  
  def after_destroy(usrecetaer)
    expire_cache(receta)
  end

  def expire_cache(receta)
     expire_fragment 'last_recipes_voted'
  end
end
