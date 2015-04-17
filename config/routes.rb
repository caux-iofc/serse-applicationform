SerseApplication::Application.routes.draw do

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'

  scope "/:locale" do
    resources :online_applications do
      resources :addresses
    end

    match '/add_member' => 'online_applications/build#add_member'
    resources :build, controller: 'online_applications/build'
    match '/application_groups/submitted' => 'application_groups#submitted', :as => 'application_group_submitted'
    match '/application_groups/submit' => 'application_groups#submit', :as => 'submit_application_group'
    resources :application_groups
    match '/form-unavailable' => 'home#form_unavailable', :as => 'form_unavailable'
    match '/cookies-disabled' => 'home#cookies_disabled', :as => 'cookies_disabled'
  end
  match '/:locale' => 'home#index'
  match '/' => 'home#index', :as => 'home'

end
