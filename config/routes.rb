Rails.application.routes.draw do


  get 'welcome/index'
  post 'welcome/search'

  # devise_scope :user do
  #   get '/members/sign_in' => 'users/sessions#member_sign_in'
  #   post '/members/sign_in' => 'users/sessions#create'
  #   get '/members/sign_up' => 'users/registrations#member_sign_up'
  #   get '/managers/sign_in' => 'users/sessions#manager_sign_in'
  #   post '/managers/sign_in' => 'users/sessions#create'
  # end
  devise_for :users, controllers:{
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }

  resources :accounts
  resources :members
  # resources :managers, only: [:edit, :update, :show]
  resources :clubs
  resources :memberships
  resources :wineries

  authenticated :user do
    root 'memberships#index', as: :authenticated_root
  end
  root 'welcome#index'


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