Rails.application.routes.draw do
  devise_for :users

  resources :questions do
    resources :answers, only: %i(new create show update destroy), shallow: true
    post 'best_answer/:answer_id', action: :best_answer, as: 'best_answer'
  end

  root 'questions#index'
end
