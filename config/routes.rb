ActionController::Routing::Routes.draw do |map|
  map.auto_complete ':controller/:action',
    :requirements => { :action => /auto_complete_for_\S+/},
    :conditions => { :method => :get }

  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.login '/login', :controller => 'sessions', :action => 'new'
  map.register '/register', :controller => 'users', :action => 'create'
  map.signup '/signup', :controller => 'users', :action => 'new'
  map.activate '/activate/:activation_code', :controller => 'users', :action => 'activate', :activation_code => nil
  map.resource :session


  map.resources :friendships, :collection => {:accept => :get, :deny => :get}
  map.resources :categories
  
  map.resources :users, :member => {:mis_recetas => :get, :mis_amigos => :get}, :collection => {:forgot_password => :post} do |users|
    users.resources :messages, :collection => { :delete_selected => :post }
  end

  map.resources :forum_cat_l2s, :as => "forums", :has_many => :forum_posts
  map.resources :forum_posts, :has_many => :forum_replies, :shallow => true
  map.resources :forum_replies, :only => [:index]
  map.resources :forum_cat_l1s
  map.resources :noticias
  map.resources :recetas, :collection => {:categoria => :get, :que_cocinar_hoy => :get, :resultatos => :get}
  map.resources :comments, :path_prefix => '/:commentable_type/:commentable_id'
  map.resources :admins
  map.home '', :controller => "noticias"

  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
