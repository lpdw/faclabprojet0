Rails.application.routes.draw do

  resources :visits, :only => [:index,:show,:new,:destroy,:create]

  get 'stat' => 'stat#home'

  resources :visits, :only => [:index,:show,:new,:destroy]

  resources :places
end
