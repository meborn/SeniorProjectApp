Rails.application.routes.draw do
  devise_for :users

  devise_scope :user do
    authenticated :user do
      root :to => 'user/users#show', as: :authenticated_root
    end
    unauthenticated :user do
      root :to => 'static#home', as: :unauthenticated_root
    end
  end

  resources :users, only: [:show]
  #get 'profile/retrieve_events', to: 'profiles#retrieve_events'
  resources :profiles, only: [:index, :show] do
    get 'openings/retrieve_events', to: 'openings#retrieve_events'
    resources :openings, only: [:index] do
      resources :appointments, only: [:new, :create]
    end
    resources :clients, only: [:create]  
  end


  namespace :user do
    resources :users, only: [:show]
    get 'openings/retrieve_events', to: 'openings#retrieve_events'
    resources :openings, except: [:index, :show, :edit] 
    resources :openings, only: [:show] do
      post :delete_recurring
    end

    resources :profiles
    resources :appointments, only: [:show, :destroy]
    resources :schedule, only: [:index] 
    get 'schedule/retrieve_events', to: 'schedule#retrieve_events'
    resources :profiles
    resources :clients, only: [:index, :show, :destroy] do
      post :approve_client
    end
    resources :notifications, only: [:index, :destroy]
    get 'notifications/new_appointments', to: 'notifications#new_appointments'
    get 'notifications/cancellations', to: 'notifications#cancellations'
    # get 'notifications/new_clients', to: 'notifications#new_clients'
    get 'notifications/new_venders', to: 'notifications#new_venders'
    resources :cancellations, only: [:show]
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
