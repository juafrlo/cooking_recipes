class FavoritesController < ApplicationController
  before_filter :login_required
  before_filter :owner_required, :only => :destroy

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
       "<span class='added_to_favorites'>#{t(:Added_to_favorites)}</span>"
    end
  end
  
  def destroy
    @favorite = Favorite.find(params[:id])
    @favorite.destroy
    render :update do |page|
      page.visual_effect  :fade, "favorite_#{@favorite.id}"
    end
  end
end