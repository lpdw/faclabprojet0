Rails.application.routes.draw do
  root 'stat#home'
  get 'stat' => 'stat#home'
  resources :visits, :only => [:index,:show,:new,:destroy,:create]
  resources :places
end
