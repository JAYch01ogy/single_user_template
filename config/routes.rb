Rails.application.routes.draw do
  root 'static_pages#home'
  devise_for :users, :controllers => { :invitations => 'users/invitations' }
  resources :users, :only => [:index, :show, :edit, :update, :destroy]
end
