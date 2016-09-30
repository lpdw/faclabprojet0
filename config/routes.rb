Rails.application.routes.draw do
  root 'visits#new'
  resources :visits, :only => [:index,:show,:new,:destroy,:create]
  resources :places
end
