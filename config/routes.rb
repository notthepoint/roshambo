Rails.application.routes.draw do
  root "home#index"

  resource :users, only: [:new]

end
