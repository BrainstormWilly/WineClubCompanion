Rails.application.routes.draw do

  get 'welcome/index'
  post 'welcome/search'

  devise_for :users, controllers: {registrations: "users/registrations"}

  # as :user do
  #   get 'users', to: 'users#show', as: :user_root
  # end

  resources :accounts, except: [:edit, :update]
  resources :clubs
  resources :memberships
  resources :users, except: [:new, :create]
  resources :wineries
  resources :subscriptions, only: [:index]


  namespace :api, defaults: {format: :json} do
    namespace :v1 do
      get "accounts", to: "accounts#by_winery"
      get "accounts/managers", to: "accounts#by_manager"
      get "activities/winery/:id", to: "activities#by_winery"
      get "clubs/wineries", to: "clubs#by_winery"
      get "clubs", to: "clubs#by_club"
      get "subscriptions", to: "subscriptions#index"
      get "wineries", to: "wineries#index"
      post "accounts", to: "accounts#search_by_winery"
      post "accounts/managers", to: "accounts#search_by_manager"
      post "clubs/wineries", to: "clubs#search_by_winery"
      post "clubs", to: "clubs#search_by_club"
      post "memberships/search", to: "memberships#search"
      post "members/search", to: "users#search_members"
      post "managers/search", to: "users#search_managers"
      post "wineries/search", to: "wineries#search"
      put "subscriptions/:id", to: "subscriptions#update"
    end
  end



  authenticated :user do
    root to: 'memberships#index', as: :authenticated_root
  end
  root to: 'welcome#index'


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
