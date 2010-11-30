class SitemapController < ApplicationController
  caches_page :index
  
  def index
    @recetas = Receta.find(:all, :order => 'created_at DESC')
    @categories = Category.find(:all, :order => 'created_at DESC')
    @advices = Advice.find(:all, :order => 'created_at DESC')
    @tags = Tag.find(:all)
    @restaurants = Restaurant.find(:all, :order => 'created_at DESC')
    @rest_categories = RestCategory.find(:all, :order => 'created_at DESC')
    @users = User.find(:all, :order => 'created_at DESC')    
    @noticias = Noticia.find(:all, :order => 'created_at DESC')
    

    headers['Content-Type'] = 'application/xml'
    render :layout => false
  end
end