Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }

  devise_scope :user do
    get 'addresses', to: 'users/registrations#new_address'
    post 'addresses', to: 'users/registrations#create_address'
  end

  root to: "top#index"
  resources :items, only: :index

  resources :users, only: [:show, :edit, :update] do
    member do 
      get 'logout'
    end
  end
    
  resources :products do
    collection do
      get 'get_category_children', defaults: { format: 'json' }
      get 'get_category_grandchildren', defaults: { format: 'json' }
    end
    member do
      get  'index',     to: 'purchase#index', :as => :index
      post 'buy',       to: 'purchase#buy'
      get  'purchased', to: 'purchase#purchased'
      
    end
  end
    resources :cards, only: [:index, :new, :create, :destroy] 
end

