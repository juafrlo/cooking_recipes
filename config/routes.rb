ActionController::Routing::Routes.draw do |map|
  map.auto_complete ':controller/:action',
    :requirements => { :action => /auto_complete_for_\S+/},
    :conditions => { :method => :get }

  #Home path
  map.home '', :controller => "noticias"
  
  #Session resources and named routes and user namedroutes
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.login '/login', :controller => 'sessions', :action => 'new'
  map.register '/registrarse', :controller => 'users', :action => 'create'
  map.signup '/darse_de_alta', :controller => 'users', :action => 'new'
  map.activate '/activate/:activation_code', :controller => 'users', :action => 'activate', :activation_code => nil
  map.resource :session
  
  #Users
  map.resources :users, :as => 'usuarios', :member => {:mis_recetas => :get, :mis_amigos => :get}, :collection => {:forgot_password => :post} do |user|
    user.resources :messages, :as => 'mensajes', :collection => { :delete_selected => :post }
  end
  map.resources :friendships, :only => [:create], :collection => {:accept => :get, :deny => :get}

  #Forums
  map.resources :forum_cat_l1s
  map.resources :forum_cat_l2s, :as => "forums", :has_many => :forum_posts
  map.resources :forum_posts, :as => "posts", :has_many => :forum_replies, :shallow => true
  map.resources :forum_replies, :as => "respuestas", :except => [:index, :show]

  #Recetas
  map.resources :recetas, :collection => {:categoria => :get, :que_cocinar_hoy => :get, :resultatos => :get}
  map.recetas_categoria 'recetas/categoria/:id', :controller => 'recetas', :action => 'categoria' 

  #Others
  map.resources :noticias 
  map.resources :categories, :as => 'categorias'
  map.resources :comments, :path_prefix => '/:commentable_type/:commentable_id'
  map.resources :admins, :as => 'administracion'

  #Default
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
