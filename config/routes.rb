Rails.application.routes.draw do
  root 'visit#show'
  get 'visit' => 'stat#show'
  resources :visits, :only => [:index,:show,:new,:destroy,:create]
  resources :places
end
