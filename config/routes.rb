ActionController::Routing::Routes.draw do |map|
  map.auto_complete ':controller/:action',
    :requirements => { :action => /auto_complete_for_\S+/},
    :conditions => { :method => :get }
  

  map.resources :messages

  map.resources :friends


  map.resources :categories

  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.login '/login', :controller => 'sessions', :action => 'new'
  map.register '/register', :controller => 'users', :action => 'create'
  map.signup '/signup', :controller => 'users', :action => 'new'
  
  map.activate '/activate/:activation_code', :controller => 'users', :action => 'activate', :activation_code => nil
  
  
  #forum_catl1/1/forum_posts/1//forum_reply/1
  
  map.resources :users, :member => {:mis_recetas => :get, :mis_amigos => :get} do |users|
    users.resources :messages, :collection => { :delete_selected => :post }
  end


  map.resource :session

  map.resources :ingredients

  map.connect 'forums', :controller => 'forums', :action => "index"

  map.resources :forum_cat_l2s, :has_many => :forum_posts, :collection => {:index_with_login => :get}
  

  map.resources :forum_posts, :has_many => :forum_replies, :shallow => true


  map.resources :forum_replies, :only => [:index]

  #map.resources :forum_replies

  map.resources :forum_cat_l1s


  map.resources :roles

  map.resources :noticias

  map.resources :steps

  map.resources :recetas, :collection => {:categoria => :get, :que_cocinar_hoy => :get, :resultatos => :get}




  map.home '', :controller => "noticias"

  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  # map.root :controller => "welcome"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing the them or commenting them out if you're using named routes and resources.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
  
  

end
