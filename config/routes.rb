Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace :api do
    namespace :v1 do
      resources :applications, param: :token, only: [:index, :create, :update] do
        resources :chats, param: :number, only: [:index, :create, :update] do
          resources :messages, param: :number, only: [:index, :create, :update]
        end
      end
    end
  end

  get 'api/v1/search', to: 'api/v1/search#search'


end
