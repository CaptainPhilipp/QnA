Rails.application.routes.draw do
  resources :questions do
    resources :answers, only: %i(new create show), shallow: true
  end

  root 'questions#index'
end
