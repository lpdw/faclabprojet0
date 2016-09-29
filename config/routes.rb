Rails.application.routes.draw do

  resources :visits, :only => [:index,:show,:new,:destroy,:create]

  get 'stat' => 'stat#home'
  post 'stat' => 'stat#choicePlace'

  resources :visits, :only => [:index,:show,:new,:destroy]

  resources :places
end
