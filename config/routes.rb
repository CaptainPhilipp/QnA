Rails.application.routes.draw do
  use_doorkeeper

  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }

  scope :users do
    post :email, controller: :users, as: :set_user_email
  end

  concern :rateable do
    post 'vote/:value', action: :vote, as: :vote, on: :member
  end

  concern :commentable do
    resources :comments, only: [:create]
  end

  resources :questions, concerns: %i(rateable commentable) do
    resources :answers, {
        only: %i(new create show update destroy),
        concerns: %i(rateable commentable),
        shallow: true
      } do
          patch :best, on: :member
        end
  end

  namespace :api do
    namespace :v1 do
      resources :profiles, only: [:index] do
        get :me, on: :collection
      end
    end
  end

  root 'questions#index'

  mount ActionCable.server => '/cable'
end
