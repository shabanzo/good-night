# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :users do
        resources :sleep_histories do
          collection do
            post :clock_in, action: :clock_in, controller: 'users/sleep_histories'
            patch :clock_out, action: :clock_out, controller: 'users/sleep_histories'
          end
        end
        resources :relationships do
          collection do
            post :follow, action: :follow, controller: 'users/relationships'
            delete :unfollow, action: :unfollow, controller: 'users/relationships'
          end
        end
      end
    end
  end
end
