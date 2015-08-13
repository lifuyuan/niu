Rails.application.routes.draw do
  resources :questions do
    resources :learnings
    collection do
      get 'show_questions'
      get 'show_statistics'
      post 'show_statistics'
    end
  end

  get 'welcome/index'
  get 'apk/download'
  get 'apk/upgrade'

  devise_for :users
  namespace :api do
    post 'users/sign_in' => 'sessions#create'
    post 'users/code' => 'sessions#createcode'
    post 'users/tokenverify' => 'sessions#tokenverify'
    post 'users/sign_up' => 'registrations#create'
    get 'get_version' => 'sessions#get_version'
  end

  namespace :android do
    # get learnings/new_learning?token=pmuFF2briG2cr9vzxCKJ
    get 'learnings/new_learning' => 'learnings#new_learning'
    # post learnings/55747f876675791088000009/create_learning?token=pmuFF2briG2cr9vzxCKJ
    post 'learnings/:question_id/create_learning' => 'learnings#create_learning'
    # get learnings/55a6020d66757911fe000002/show_learning?token=pmuFF2briG2cr9vzxCKJ
    get 'learnings/:learning_id/show_learning' => 'learnings#show_learning'
    get 'welcome/errorpage'
    # get learnings/one/lock?token=pmuFF2briG2cr9vzxCKJ
    get 'learnings/:difficulty_value/lock' => 'learnings#lock'
    # get learnings/55a6020d66757911fe000002/keep?token=pmuFF2briG2cr9vzxCKJ
    get 'learnings/:learning_id/keep' => "learnings#keep"
    # get learnings/learning_info?token=pmuFF2briG2cr9vzxCKJ
    get 'learnings/learning_info' => "learnings#learning_info"

    get 'learnings/learning_record' => "learnings#learning_record"
    get 'learnings/favorite' => "learnings#favorite"
    get 'learnings/top_ten_yesterday' => "learnings#top_ten_yesterday"
    get 'learnings/top_ten' => "learnings#top_ten"
    get 'learnings/:learning_id/learning_show' => 'learnings#learning_show'

    get 'learnings/settings' => 'learnings#settings'
    get 'learnings/set_difficulty' => 'learnings#set_difficulty'
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
