Rails.application.routes.draw do
  root "home#index"
  resource :sessions, only: %i[create] do
    collection do
      get "logout"
    end
  end
end
