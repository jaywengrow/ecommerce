Rails.application.routes.draw do
  
  devise_for :users

  root to: "pages#home"

  resources :carted_products
  resources :orders
  resources :products
  resources :users

  get '/orders/thank-you/:id' => 'orders#thank_you', as: :order_thank_you 
  get '/dashboard' => 'pages#dashboard' 
  get '/redirect' => 'pages#redirect'
  get '/callback' => 'pages#callback'
  get '/analytics' => 'pages#analytics'
end
