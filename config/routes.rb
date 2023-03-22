# frozen_string_literal: true

MyLibraryNYC::Application.routes.draw do

  devise_for :users, :path => "users", :path_names => { :sign_in => 'login', :sign_out => 'logout', :sign_up => 'signup' }, 
                     :controllers => { :registrations => 'users/registrations', :sessions => 'users/sessions' }

  get 'hello_world', to: 'hello_world#index'
  get 'teacher_set_data', to: 'teacher_sets#teacher_set_data'

  resources :registrations, only: [:create, :update, :put, :patch, :post]

  get 'timeout_check' => 'sessions#timeout_check'
  get 'timeout' => 'sessions#timeout'
  get '/logged_in', to: 'sessions#logged_in?'
  get 'extend_session_iframe' => 'home#extend_session_iframe'
  get 'home/calendar_event/:filename', to: 'home#mln_calendar'
  get 'home/calendar_event/error', to: 'home#calendar_event_error'
  get 'home/calendar_event', to: 'home#calendar_event'
  get 'home/newsletter_confirmation_msg', to: 'home#newsletter_confirmation_msg'
  get '/menu_of_services/:filename', to: 'home#menu_of_services'
  get '*', :to => 'settings#page_not_found'

  resources :teacher_sets do
    resources :holds
  end
  resources :books
  resources :schools, :only => [:index, :create]
  resources :faqs

  # Active-Admin redirect to login page.
  match '/users/logout' => 'settings#activeadmin_redirect_to_login', via: [:get, :delete]
  # match '/admin/password' => 'settings#reset_admin_password_message', via: [:get, :delete, :post, :put]
  match 'teacher_sets/:id/teacher_set_holds' => 'teacher_sets#teacher_set_holds', via: [:get, :patch, :post]
  get 'teacher_set_details/:id' => 'teacher_sets#teacher_set_details'
  get 'book_details/:id' => 'books#book_details'
  get 'ordered_holds/:cache_key' => 'holds#ordered_holds_details'
  match 'holds/:id/cancel' => 'holds#holds_cancel_details', via: [:get, :post]
  match 'holds/:id/cancel_details' => 'holds#cancel_details', via: [:get, :post]

  resources :holds
  get '/check_email', to: 'users#check_email'
  get '/mln_banner_message', to: 'settings#mln_banner_message'
  post '/require_login', to: 'application#require_login'
  post '/redirect_to_angular', to: 'application#redirect_to_angular'

  match 'settings' => 'settings#index', via: [:get, :patch, :post]
  match 'account' => 'settings#index', :as => :account, via: [:get, :patch, :post, :put]
  match '/news_letter/index' => 'news_letter#index', via: [:get, :post]

  get '/home/get_mln_file_names' => 'home#mln_file_names'
  get '/secondary_menu' => 'home#secondary_menu'

  match '/news_letter/validate_news_letter_email_from_user_sign_up_page' => 'news_letter#validate_news_letter_email_from_user_sign_up_page', 
        via: [:get, :post]
  match '/news_letter/news_letter_email_is_valid' => 'news_letter#news_letter_email_is_valid', via: [:get, :post]

  get '/docs/mylibrarynyc', to: 'home#swagger_docs'
  get 'exceptions' => 'exceptions#render_error', :as => :render_error

  match '/account_details' => 'settings#acccount_details', via: [:get, :post]
  match '/signin' => 'settings#signin', via: [:get, :post]
  match '/signup' => 'settings#signup', via: [:get, :post]
  get '/sign_up_details' => 'settings#sign_up_details'

  root :to => 'home#index'
  get '/participating-schools' => 'schools#participating_schools_data'
  get '/contact' => 'home#help'
  get '/faq' => 'home#faq_data'
  match '/newsletter_confirmation' => 'home#newsletter_confirmation', via: [:get, :post]
  get '/help/access-digital-resources' => 'home#digital_resources'

  get 'app', to: redirect('/')

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  post 'api/v0.1/mylibrarynyc/teacher-sets' => 'api/v01/bibs#create_or_update_teacher_set'
  delete 'api/v0.1/mylibrarynyc/teacher-sets' => 'api/v01/bibs#delete_teacher_set'
  post 'api/v0.1/mylibrarynyc/item-availability' => 'api/v01/items#update_availability'
  get 'api/unauthorized' => 'api/v01/general#unauthorized'
end
