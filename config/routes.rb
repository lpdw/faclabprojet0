Rails.application.routes.draw do

  resources :visits, :only => [:index,:show,:new,:destroy,:create]
  resources :places
end
