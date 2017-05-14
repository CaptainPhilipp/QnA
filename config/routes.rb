Rails.application.routes.draw do
  devise_for :users

  resources :questions do
    resources :answers, only: %i(new create show update destroy), shallow: true do
      patch :best
    end
  end

  root 'questions#index'
end
