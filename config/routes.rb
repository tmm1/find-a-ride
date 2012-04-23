PoolRide::Application.routes.draw do

  devise_for :users , :controllers => { :omniauth_callbacks => "users/omniauth_callback" } do
    get '/signin' => 'devise/sessions#new'
    get '/signup', :to => "devise/registrations#new"
    get '/users/confirm', :to => 'devise/confirmations#new'
    get '/users/reset_password', :to => 'devise/passwords#new'
    get '/users/change_password', :to => 'devise/passwords#edit'
  end

  match '/about' => 'home#about'
  match '/index' => 'home#index'
  match '/users/:user_id/recent' => 'hook_ups#index', :as => :recent

  authenticated :user do
    root :to => 'rides#index'
  end
  root :to => 'home#index'

  resources :home do
    collection do
      get 'about'
      get 'index'
      get 'inactive'
      post 'contact'
    end
  end
  
  resources :rides do
    collection do
      post 'search'
    end
  end
  
  resources :ride_requests do
    collection do
      get 'search'
    end
  end
  
  resources :ride_offers do
    collection do
      get 'search'
    end
  end
  
  resources :users do
    resources :hook_ups
    resources :rides do
      collection do
        get 'list'
      end
    end
  end
 
  resources :users do
    resources :invites do
      collection do
        post 'send_invite'
        get 'get_gmail_contacts'
      end
    end
  end
  
  post "home/authorize" 
  match '/location_search' => 'application#location_search', :as => :location_search
  match '/geocode_city' => 'application#geocode_city'
  match '/twitter' => 'users/omniauth_callback#twitter'
  match '/register_user_with_twitter' => 'users/omniauth_callback#register_user_with_twitter'
 
  # The priority is based upon order of creation:
  # first created -> highest priority.
  match "/errors/not_found" => "errors#not_found" , :as => :not_found
  match "/errors/internal_server_error" =>"errors#internal_server_error" , :as => :internal_server_error
  match "/errors/method_not_allowed" => "errors#method_not_allowed" , :as => :method_not_allowed
  match "/errors/unprocessable_entity" => "errors#unprocessable_entity" , :as => :unprocessable_entity
  match "/errors/access_denied" => "errors#access_denied" , :as => :access_denied
  
  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
