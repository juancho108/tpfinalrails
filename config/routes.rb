Rails.application.routes.draw do
  

  resources :origin_sales
  devise_for :users
  scope '/admin' do
    resources :users
  end
  resources :clients
  resources :sales do
    member do 
      get :confirm_sale
      get :cancel_sale
      get :movements
      get :close_sale
    end
  end
  resources :pictures

  resources :products do
    resources :records
    resources :copies do
      member do 
        get :sale
        post :create_sale
        get :edit
        put :update
      end
    end 
    member do 
      get :stock_simple
      get :stock_complejo
      post :create_stock_simple
      post :create_stock_complejo
    end
  end

  resources :categories
  resources :finances
  resources :movements
  get 'home/index'


  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'home#index'

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
