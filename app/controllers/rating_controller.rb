class RatingController < ApplicationController
  before_filter :login_required
  
  def rate
    Rating.rate(params[:id],params[:rating],params[:type],current_user)
    if params[:type] == 'Receta'
      @obj = Receta.find(params[:id])
    end
  end
end