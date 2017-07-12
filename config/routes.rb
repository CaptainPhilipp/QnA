require 'sidekiq/web'

Rails.application.routes.draw do
  authenticate :user, ->(user) { user.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  use_doorkeeper

  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }

  scope :users do
    post :email, controller: :users, as: :set_user_email
  end

  concern :rateable do
    post 'vote/:value', action: :vote, as: :vote, on: :member
  end

  concern :commentable do
    resources :comments, only: %i(create)
  end

  resources :questions, concerns: %i(rateable commentable) do
    resources :answers, {
        only: %i(new create show update destroy),
        concerns: %i(rateable commentable),
        shallow: true
      } do
          patch :best, on: :member
        end

    resources :subscriptions, only: [:create] do
      delete :destroy, on: :collection
      get    :destroy, on: :collection # for mailer
    end
  end

  namespace :api do
    namespace :v1 do
      resources :questions, only: %i(show index create) do
        resources :answers, only: %i(show create), shallow: true
      end

      resources :profiles, only: %i(index) do
        get :me, on: :collection
      end
    end
  end

  root 'questions#index'

  mount ActionCable.server => '/cable'
end
