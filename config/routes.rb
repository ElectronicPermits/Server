OpenPermits::Application.routes.draw do
  resources :static_permissions

  devise_for :users, :skip => [:registrations], 
    :controllers => { :registrations => "manage/users", 
                      :sessions => "manage/sessions" }

  # Root
  root 'service_types#index'

  # Routes for public access
  resources :service_types, only: [:index, :show]
  resources :vehicles, only: [:index, :show]
  resources :trusted_apps, only: [:index]

  #Admin routes
  namespace :manage do
    root 'trusted_apps#index'
    resources :trusted_apps
    as :user do
      resources :users
    end
  end
  
  #API routes
  #API has access to all but permissions and trusted_apps
  # namespace :api, :path => "", :constraints => { :subdomain => "api" }, :defaults => {:format => :json} do 
  namespace :api, :defaults => {:format => :json} do 
    namespace :v1, :defaults => {:format => :json} do
      #Create or read
      resources :ratings, only: [:create, :index, :show]
      resources :services, only: [:create, :index, :show]

      #No deleting
      resources :consumers, only: [:create, :index, :show, :update]
      resources :violations, only: [:create, :index, :show, :update]
      resources :vehicles, only: [:create, :index, :show, :update]
      resources :permits, only: [:create, :index, :show, :update]
      resources :people, only: [:create, :index, :show, :update]
      resources :companies, only: [:create, :index, :show, :update]
      resources :service_types

      # Look up permits by beacon id!
      get 'permits/:beacon_id' => 'permits#show', as: 'permit_by_beacon'

   end
  end
end
