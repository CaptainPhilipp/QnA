Rails.application.routes.draw do
  devise_for :users

  concern :rateable do
    post 'vote/:value', action: :vote, as: :vote, on: :member
  end

  resources :questions, concerns: :rateable do
    resources :answers, only: %i(new create show update destroy), concerns: :rateable, shallow: true do
      patch :best, on: :member
    end
  end

  root 'questions#index'

  mount ActionCable.server => '/cable'
end
