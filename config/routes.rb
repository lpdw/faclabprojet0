Rails.application.routes.draw do
<<<<<<< HEAD
  resources :visits, :only => [:index,:show,:new,:destroy,:create]
=======
  get 'stat' => 'stat#home'

  resources :visits, :only => [:index,:show,:new,:destroy]
>>>>>>> 1b98298364adf89d64fabbeb646509121227b52c
  resources :places
end
