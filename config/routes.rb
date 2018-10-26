Rails.application.routes.draw do
  resources :users do
    resources :email_history, only: :index
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
