# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :users do
        resources :sleep_histories do
          collection do
            post :clock_in, action: :clock_in, controller: 'users/sleep_histories'
          end
        end
      end
    end
  end
end
