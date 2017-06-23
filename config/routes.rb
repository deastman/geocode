Rails.application.routes.draw do
  resources :locations, only: [:create, :new]
  root 'locations#new'
end
