OpenPermits::Application.routes.draw do

  # Routes for public access
  resources :violations, only: [:index, :show]
  resources :consumers, only: [:index, :show]
  resources :ratings, only: [:index, :show]
  resources :services, only: [:index, :show]
  resources :service_types, only: [:index, :show]
  resources :vehicles, only: [:index, :show]
  resources :permits, only: [:index, :show]
  resources :people, only: [:index, :show]
  resources :addresses, only: [:index, :show]
  resources :companies, only: [:index, :show]
  resources :trusted_apps, only: [:index]

  #Admin routes
  #TODO
  namespace :manage do
    resources :trusted_apps
    resources :app_roles
  end
  
  #API routes
  #API has access to all but app_roles and trusted_apps
  namespace :api, :path => "", :constraints => { :subdomain => "api" }, :defaults => {:format => :json} do 
    namespace :v1 do
      #Create or read
      resources :ratings, only: [:create, :index, :show]
      resources :services, only: [:create, :index, :show]

      #No deleting
      resources :consumers, only: [:create, :index, :show, :update]
      resources :violations, only: [:create, :index, :show, :update]
      resources :vehicles, only: [:create, :index, :show, :update]
      resources :permits, only: [:create, :index, :show, :update]
      resources :people, only: [:create, :index, :show, :update]
      resources :addresses, only: [:create, :show, :update]
      resources :companies, only: [:create, :index, :show, :update]

      #Fully editable
      resources :service_types, only: [:create, :index, :show, :update, :destroy]

   end
  end

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
