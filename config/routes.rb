Rails.application.routes.draw do
  get 'stat' => 'stat#home'
  post 'stat' => 'stat#choicePlace'

  resources :visits, :only => [:index,:show,:new,:destroy]
  resources :places
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
