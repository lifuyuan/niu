Rails.application.routes.draw do
  resources :questions do
    resources :learnings
    collection do
      get 'show_questions'
    end
  end

  get 'welcome/index'

  devise_for :users
  namespace :api do
    post 'users/sign_in' => 'sessions#create'
    post 'users/sign_up' => 'registrations#create'
  end

  namespace :android do
    # get learnings/new_learning?token=pmuFF2briG2cr9vzxCKJ
    get 'learnings/new_learning' => 'learnings#new_learning'
    # post learnings/55747f876675791088000009/create_learning?token=pmuFF2briG2cr9vzxCKJ
    post 'learnings/:question_id/create_learning' => 'learnings#create_learning'
    # get learnings/55a6020d66757911fe000002/show_learning?token=pmuFF2briG2cr9vzxCKJ
    get 'learnings/:learning_id/show_learning' => 'learnings#show_learning'
  end
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'welcome#index'

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
