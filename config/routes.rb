BreadExpress::Application.routes.draw do

  # Routes for main resources
  resources :addresses
  resources :customers
  resources :orders
  resources :items
  resources :users
  resources :item_prices
  resources :sessions
  
  # Authentication routes
  get 'signup' => 'customers#new', as: :signup
  get 'logout' => 'sessions#destroy', as: :logout
  get 'login' => 'sessions#new', as: :login

  # Semi-static page routes
  get 'home' => 'home#home', as: :home
  get 'about' => 'home#about', as: :about
  get 'contact' => 'home#contact', as: :contact
  get 'privacy' => 'home#privacy', as: :privacy
  get 'dashboard' => 'home#dashboard', as: :dashboard
  get 'search' => 'home#search', as: :search
  get 'cylon' => 'errors#cylon', as: :cylon
  get 'cart' => 'orders#cart', as: :cart
  
  # Set the root url
  root :to => 'home#home'  
  
  # Named routes
  get 'add_item/:id' => 'orders#add_item', as: :add_item
  get 'remove_item/:id' => 'orders#remove_item', as: :remove_item
  get 'checkout' => 'orders#new', as: :checkout
  get 'bakers' => 'home#bakers', as: :bakers
  get 'shippers' => 'home#shippers', as: :shippers
  get 'employees' => 'users#display_employees', as: :employees
  get 'clear_items_in_cart' => 'orders#clear_items_in_cart', as: :clear_items_in_cart
  get 'item_shipped/:id' => 'orders#item_shipped', as: :item_shipped
  
  # Last route in routes.rb that essentially handles routing errors
  get '*a', to: 'errors#routing'
end
