# frozen_string_literal: true

MyLibraryNYC::Application.routes.draw do

  devise_for :users, :path => "users", :path_names => { :sign_in => 'start', :sign_out => 'signout', :sign_up => 'signup' }, :controllers => { :registrations => :registrations, :sessions => :sessions }

  devise_scope :user do
    get 'timeout_check' => 'sessions#timeout_check'
    get 'timeout' => 'sessions#timeout'
  end

  get 'extend_session_iframe' => 'home#extend_session_iframe'

  resources :teacher_sets do
    resources :holds
  end
  resources :books
  resources :schools, :only => [:index, :create]
  match 'holds/:id/cancel' => 'holds#cancel', :as => :holds_cancel, via: [:get, :post]
  match 'teacher_sets/:id/teacher_set_holds' => 'teacher_sets#teacher_set_holds', via: [:get, :patch, :post]

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
  post '/require_login', to: 'application#require_login'
  post '/redirect_to_angular', to: 'application#redirect_to_angular'

  match 'app' => 'angular#index', :as => :app, via: [:get, :patch, :post]

  match 'settings' => 'settings#index', via: [:get, :patch, :post]

  match 'account' => 'settings#index', :as => :account, via: [:get, :patch, :post]
  match '/news_letter/index' => 'news_letter#index', via: [:get, :post]
  match '/news_letter/validate_news_letter_email_from_user_sign_up_page' => 'news_letter#validate_news_letter_email_from_user_sign_up_page', via: [:get, :post]
  match '/news_letter/news_letter_email_is_valid' => 'news_letter#news_letter_email_is_valid', via: [:get, :post]

  get '/docs/mylibrarynyc', to: 'home#swagger_docs'
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
  match '/about/participating-schools' => 'schools#index', via: [:get]
  match '/help' => 'home#help', via: [:get]
  match '/faq' => 'home#faq', via: [:get]
  match '/newsletter_confirmation' => 'home#newsletter_confirmation', via: [:get, :post]
  match '/help/access-digital-resources' => 'home#digital_resources', via: [:get]

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  post 'api/v0.1/mylibrarynyc/teacher-sets' => 'api/v01/bibs#create_or_update_teacher_set'
  delete 'api/v0.1/mylibrarynyc/teacher-sets' => 'api/v01/bibs#delete_teacher_set'

  post 'api/v0.1/mylibrarynyc/item-availability' => 'api/v01/items#update_availability'

  get 'api/unauthorized' => 'api/v01/general#unauthorized'
  get 'home/calendar_event/:filename', to: 'home#mln_calendar'


  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
