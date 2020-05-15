Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :books, only: [:index, :show] do
    resources :line_items, only: [:create]
  end
  resources :line_items, only: [:update, :destroy]

  resources :checkouts, module: :checkout, only: [] do
    resources :payments, only: [:new]
    resources :shipments, only: [:new]
  end

  namespace :checkout do
    resources :payments, only: [:update]
    resources :shipments, only: [:update]
  end

  resources :orders, only: [:show]

  root to: redirect("/books")
end
