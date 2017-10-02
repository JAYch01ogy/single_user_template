Rails.application.routes.draw do
  match '/users', to: 'users#index', via: 'get'

  devise_for :users, :controllers => { :invitations => 'users/invitations' }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'static_pages#home'
end
