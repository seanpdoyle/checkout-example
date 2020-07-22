Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :books, only: [:index, :show] do
    resources :line_items, only: [:create]
  end
  resources :line_items, only: [:update, :destroy]

  root to: redirect("/books")
end
