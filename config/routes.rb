SerseApplication::Application.routes.draw do
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

  get 'nagios/application_groups' => 'nagios#application_groups'

  scope "/payments" do
    get '/callback/:status' => 'payments#callback'
    get '/post' => 'payments#post'
    get '/redirect_to_processor' => 'payments#redirect_to_processor', :as => 'payments_redirect_to_processor'
  end

  scope "/:locale" do
    resources :online_applications do
      resources :addresses
    end

    get '/add_family_member' => 'online_applications/build#add_family_member'
    get '/add_group_member' => 'online_applications/build#add_group_member'
    resources :build, controller: 'online_applications/build'
    get '/application_groups/submitted' => 'application_groups#submitted', :as => 'application_group_submitted'
    get '/application_groups/submit' => 'application_groups#submit', :as => 'submit_application_group'
    resources :application_groups
    get '/form-unavailable' => 'home#form_unavailable', :as => 'form_unavailable'
    get '/cookies-disabled' => 'home#cookies_disabled', :as => 'cookies_disabled'
    get '/error' => 'home#error', :as => 'error'

    get '/conference_packages' => 'conference_packages#index'
  end
  get '/:locale' => 'home#index'
  get '/' => 'home#index', :as => 'home'

end
