Rails.application.routes.draw do
  root 'visits#index'
  resources :visits, :only => [:index,:show,:new,:destroy,:create]
  resources :places
end
