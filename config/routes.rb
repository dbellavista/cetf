Cetf::Application.routes.draw do

  resources :participants

  resources :challenges do
    post 'solve', :on => :member
    post 'writeup', :on => :member
    get 'writeups', :on => :member
  end

  resources :attachments

  match '/auth/:provider/callback' => 'sessions#create'
  match '/auth/failure' => 'sessions#failure'

  match '/login' => 'sessions#new', :as => :login
  match '/logout' => 'sessions#destroy', :as => :logout

  root :to => 'root#index'
end
