Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :books, only: [:index, :show] do
    resources :line_items, only: [:create]
  end
  resources :line_items, only: [:update, :destroy]

  scope module: :checkouts do
    resources :orders, only: [] do
      resources :shipments, only: [:new]
      resources :payments, only: [:new]
    end

    resources :confirmations, only: [:show]
    resources :payments, only: [:update]
    resources :shipments, only: [:update]
  end

  root to: redirect("/books")
end
