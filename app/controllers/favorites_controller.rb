class FavoritesController < ApplicationController
  before_filter :login_required

  def create
    if params[:type] == "Receta"
      current_user.has_favorite(Receta.find(params[:obj_id]))
    elsif params[:type] == "Restaurant"
      current_user.has_favorite(Restaurant.find(params[:obj_id]))
    elsif params[:type] == "Advice"
      current_user.has_favorite(Advice.find(params[:obj_id]))
    end
    render :update do |page|
      page.replace_html 'favorite_link',
       "<span style='color:green;'>#{t(:Added_to_favorites)}</span>"
    end
  end
  
  def destroy
    # render none
  end
end