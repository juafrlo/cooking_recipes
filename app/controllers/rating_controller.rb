class RatingController < ApplicationController
  before_filter :login_required
  cache_sweeper :receta_sweeper
  
  def rate
    rate = Rating.rate(params[:id],params[:rating],params[:type],current_user)
    if params[:type] == 'Receta'       
      @obj = Receta.find(params[:id])
      @obj.user.update_recetas_avg
    end
  end
end