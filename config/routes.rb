# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace :api do
    namespace :v1 do
      namespace :merchants do
        get '/find', to: "search#show"
      end

      resources :merchants, only: %i[index show] do
        resources :items, only: %i[index show]
      end

      resources :items
      get 'items/:item_id/merchant', to: 'merchants#show'
    end
  end
end
