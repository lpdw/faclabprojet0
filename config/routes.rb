Rails.application.routes.draw do

  root 'sessions#new'
  post   '/',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'

  resources :visits, :only => [:index,:show,:new,:destroy,:create]
  resources :places

  # recuperation de la requete ajax via les filtres
  post 'visits/index' => 'visits#index'
end
