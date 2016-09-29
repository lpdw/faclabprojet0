Rails.application.routes.draw do
  resources :visits, :only => [:index,:show,:new,:destroy]
  resources :places
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
