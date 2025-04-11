Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :items, only: [:index, :show, :create] do
        get 'file_url', on: :member
      end
    end
  end
end