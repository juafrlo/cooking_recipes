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
       "<span class='added_to_favorites'>#{t(:Added_to_favorites)}</span>"
    end
  end
  
  def destroy
    @favorite = Favorite.find(:first,
      :conditions => {:user_id => current_user.id, :favorable_type => params[:type],
        :favorable_id => params[:id]})
    @favorite.destroy unless @favorite.blank?
    render :update do |page|
      unless @favorite.blank? 
        page.visual_effect  :fade, "favorite_#{@favorite.favorable_id}"
      end
    end
  end
end