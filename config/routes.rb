MyLibraryNYC::Application.routes.draw do

  devise_for :users, :path => "users", :path_names => { :sign_in => 'start', :sign_out => 'signout', :sign_up => 'signup' }, :controllers => { :registrations => :registrations, :sessions => :sessions }

  devise_scope :user do
    match 'timeout_check' => 'sessions#timeout_check', via: :get
    match 'timeout' => 'sessions#timeout', via: :get
  end

  get 'extend_session_iframe' => 'home#extend_session_iframe'

  resources :teacher_sets do
    resources :holds
  end
  resources :books
  resources :schools, :only => [:index]
  match 'holds/:id/cancel' => 'holds#cancel', :as => :holds_cancel
  resources :holds

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)
  get '/check_email', to: 'users#check_email'
  match 'app' => 'angular#index', :as => :app
  match 'settings' => 'settings#index'
  match 'account' => 'settings#index', :as => :account
  match 'help' => 'home#help', :as => :help
  get 'exceptions' => 'exceptions#render_error', :as => :render_error
  # match 'users/autocomplete_school_name' => 'users#autocomplete_school_name', :as => :autocomplete_school_name

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
  root :to => 'home#index'

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  namespace :api do
    namespace :v1 do
      post '/teacher_sets' => 'bibs#create_or_update_teacher_sets'
      delete '/teacher_sets' => 'bibs#delete_teacher_sets'
    end
  end

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
